
resource "tls_private_key" "terrafrom_generated_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.terrafrom_generated_private_key.public_key_openssh
}

resource "local_file" "generated_key" {
  filename = "${aws_key_pair.generated_key.key_name}.pem"
  file_permission = "600"
  directory_permission = "700"
  content  = tls_private_key.terrafrom_generated_private_key.private_key_pem
}

resource "aws_instance" "tf_terra_ec2_instance" {
  ami           = "ami-0427090fd1714168b"
  instance_type = "t2.micro"
  #key_name      = "Tfterraec2keypair"
  key_name = aws_key_pair.generated_key.key_name

  subnet_id                   = aws_subnet.tf_terra_ec2_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.tf_terra_ec2_sg.id]
  associate_public_ip_address = true

   user_data                   = file("install_jenkins.sh")

  tags = {
    "Name" : "jenkins Machine"

  }
}