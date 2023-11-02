#VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Declare the data source
data "aws_availability_zones" "available" {}

# subnet
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Default subnet for ${data.aws_availability_zones.available.names[0]}"
  }
}

# create security group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = [22, 8080]
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


# create ssh key in AWS
resource "aws_key_pair" "jenkins-key" {
  key_name   = "jenkins-key"
  public_key = file("${path.module}/id_rsa.pub")
}

# output "printkey" {
#   value = aws_key_pair.jenkins-key.key_name
# }


# Create ec2 instance with the ssh key
resource "aws_instance" "jenkins_server" {
  ami                    = "ami-06006e8b065b5bd46"
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name               = aws_key_pair.jenkins-key.key_name
}


# create null rescource and execute install_jenkins.sh script

resource "null_resource" "name" {

  #ssh into instance
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/id_rsa")
    host = aws_instance.jenkins_server.public_ip
  }

  #copy the install_jenkins.sh from local to ec2 instance

  provisioner "file" {
    source = "./install_jenkins.sh"
    destination = "/tmp/install_jenkins.sh"
  }

  # set permission execute the install_jenkins.sh file
  provisioner "remote-exec" {
    inline = [ 
      "sudo chmod +x /tmp/install_jenkins.sh",
      "sh /tmp/install_jenkins.sh"
    ]

  }
  depends_on = [ aws_instance.jenkins_server ]
}
