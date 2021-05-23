#Creating  private key

resource "tls_private_key" "privatekey" {
   algorithm = "RSA"
   rsa_bits = "4096"
}

resource "aws_key_pair" "key" {
 #key_name   = "OSkey"
  key_name   = var.key_name
  public_key = tls_private_key.privatekey.public_key_openssh
}

output "mykey"{
  value = aws_key_pair.key.key_pair_id
}
