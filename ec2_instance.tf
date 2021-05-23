resource "aws_instance" "instance" {
  ami = "ami-0d5eff06f840b45e9"
  instance_type = "t2.micro"
  security_groups = [ aws_security_group.security.name ]
  key_name = aws_key_pair.key.key_name
  tags = {
      Name = "Webserver"
  }
}

resource "null_resource" "command" {
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = tls_private_key.privatekey.private_key_pem
    # priavte_key = file("\path")
    host = aws_instance.instance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd git -y",
      "sudo systemctl restart httpd",
      "sudo systemctl enable httpd",
    ]
}
}

output "myinstanceid"{
  value = aws_instance.instance.id
}

output "myinstance_publicip"{
  value = aws_instance.instance.public_ip
}
