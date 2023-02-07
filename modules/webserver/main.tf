
resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name: "${var.env_prefix}-sg"
    }
}
resource "aws_key_pair" "ssh-key" {
    key_name = "server-key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDY4O45C0rlPR1r8ruJovEOPWrYCYdiJb/qT8O9zt/oXVray78M9+tMqRXFuItIiadnUJVqzJ0pdlpbhfMWbj8N6/7zh4Ce6Lu1LwPAWapiMqenaGCaF9WzZqTGjA8oZuHoCsk29RkcDECmYEX4yZBhHMfeW131FMMth676gmTn2qjqs3MaLjBQ/jJdWR7kfCX773Ex7O4x+k63Db9zSXS19LZFSvYKyKSiAc/ZCu+BLn1r74loslAhLOJQoeQob0WVZvLjPz504rh7CXlcfd4hAskDAQU/Y4acVbaltJlEjs8IqdCvJHzZz+u0nMS5x6OGQjvDwS9YyVtSFddrZBFzzu+truer0d4Y7YxOS6ddkDzSKTmyHqjVkgdURmpx+DBbRjekyE0OPeOHd70F0Sqm/UkivRUo14htRTeTRGUD2O6Uj4uAK9pdfx6F27JOAmf4NB+G/2BUXWf6DpPTw7R2LzrPlWPquB8LQjNYBdGr25MG/iM1jXgQ8xBNgJOXPQs= abd@DESKTOP-5RH0GUD"
    
}


data "aws_ami" "latest-amazon-linux-image"{
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = [var.image_name]
    }
}

resource "aws_instance" "myapp-server" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type

    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.availability_zone

    associate_public_ip_address = true
    key_name = "vockey"

    user_data = file("modules/webserver/entry_script.sh")

    tags = {
        Name = "${var.env_prefix}-server"
    }
}