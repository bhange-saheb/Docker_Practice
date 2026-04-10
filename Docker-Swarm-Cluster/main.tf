provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "swarm_sg" {
  vpc_id      = var.vpc-id
  name        = "swarm_sg"
  description = "Allow all inbound traffic and SSH"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.1.0/32"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.1.1.0/32"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.2.1.0/32"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # lifecycle {
  #   ignore_changes = [
  #     ingress,
  #   ]
  # }
}

resource "aws_instance" "swarm_master" {
  count                  = 1
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index]
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.swarm_sg.id]

  tags = {
    Name = "swarm-master-${count.index + 1}"
  }

  provisioner "file" {
    source      = var.key_path
    destination = "/home/ubuntu/XXXXXX.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.key_path)
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker ubuntu",
      "chmod 600 /home/ubuntu/XXXXXX.pem"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.key_path)
      host        = self.public_ip
    }
  }
}

resource "aws_instance" "swarm_worker" {
  count                  = 2
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_ids[count.index + 1]
  vpc_security_group_ids = [aws_security_group.swarm_sg.id]

  tags = {
    Name = "swarm-worker-${count.index + 1}"
  }

  provisioner "file" {
    source      = var.key_path
    destination = "/home/ubuntu/XXXXXX.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.key_path)
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker ubuntu",
      "chmod 600 /home/ubuntu/XXXXXX.pem"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.key_path)
      host        = self.public_ip
    }
  }
}

resource "null_resource" "swarm_init" {
  provisioner "remote-exec" {
    inline = [
      "docker swarm init --advertise-addr ${aws_instance.swarm_master[0].public_ip}"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.key_path)
      host        = aws_instance.swarm_master[0].public_ip
    }
  }

  depends_on = [aws_instance.swarm_master]
}

resource "null_resource" "swarm_join_worker" {
  count = 2

  provisioner "remote-exec" {
    inline = [
      "docker swarm join --token $(ssh -o StrictHostKeyChecking=no -i /home/ubuntu/XXXXXX.pem ubuntu@${aws_instance.swarm_master[0].public_ip} 'docker swarm join-token worker -q') ${aws_instance.swarm_master[0].public_ip}:2377"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.key_path)
      host        = aws_instance.swarm_worker[count.index].public_ip
    }
  }

  depends_on = [null_resource.swarm_init]
}
