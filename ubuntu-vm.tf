resource "aws_security_group" "allow_SSH_ubuntu" {
  name        = "allow_SSH_ubuntu"
  description = "Allow SSH inbound traffic"


  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+Kt/ae1NCIqkm2B8IdOnDl/nTgQ2GRnpFMAO2Ebgj6vUpK6uTPcLQXvKrrXeFLuGCCOMrz4S3eOSAGSvCWmiQmXDTVCpPf9fbD7bIcEueZEFfsJ8Y3FKaczhTRMSeqjsa/ICPJs4+lO7agzJJwgdnPJIz6bhSQDIOtg2funp7NR0NtF8yLDwR9V3LOv1hsQhQmHGXrCiuNwvGxF/wQhFtwqDUuyL+BHPyn5oBFmshG6d54c6PHumnagcjRz8JiHNJGsVERP1ZEkQ6m+voW4xy/N4JwUZhXc7P3yi5caUarrLB9ZMQu5KkhHqbUldjA6iYZ3csXo3EIexxwbkY9BrpVHiEEvGlw8cn8Kzat5pt16N6H0vlju1ADd2+z8RMmPXjW2egYAMR4tb5hBnKdV4DSgTCDsK0MBOEgak3OpeYx2b1yLCIJ4oamkfB3/DYb7vv/U4oERn1GwgqAfwqFNJ0tEu/8QA4BJgITx9X9IDpfr3T7Nq3aHkbNtgAw9//0B8= chethankvvcegma@ip-172-31-18-21
"
}

####### Ubuntu VM #####


resource "aws_instance" "ubuntu" {
  ami                    = "ami-007855ac798b5175e"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.deployer.key_name
  count                  = 3
  vpc_security_group_ids = ["${aws_security_group.allow_SSH_ubuntu.id}"]
  tags = {
    "Name" = "UBUNTU-${count.index}"
    "ENV"  = "Dev"
  }


  depends_on = [aws_key_pair.deployer]

}

output "ubuntu" {
  value       = aws_instance.ubuntu.*.public_ip
  description = "Ubuntu vm public IP"
}
