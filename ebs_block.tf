
resource "aws_ebs_volume" "ebs_vol" {
  availability_zone = aws_instance.instance.availability_zone
  size              = 5

  tags = {
    Name = "${var.ebs_vol_name}"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs_vol.id
  instance_id = aws_instance.instance.id
  force_detach = true
}

output "myebsid" {
    value = aws_ebs_volume.ebs_vol.id
}

output "myebs_blockname" {
  value = aws_volume_attachment.ebs_att.device_name
}

resource "null_resource" "command2" {
  depends_on = [
    aws_volume_attachment.ebs_att
  ]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = tls_private_key.privatekey.private_key_pem
    # priavte_key = file("/path")
    host = aws_instance.instance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkfs.ext4 /dev/xvdh",
      "sudo mount /dev/xvdh  /var/www/html",
      "sudo df -h",
      "sudo rm -rf /var/www/html/*",
      "sudo git clone https://github.com/24-komal/static_html_code.git /var/www/html/",
    ]
}
}

resource "null_resource" "command3" {
  depends_on = [
      null_resource.command2
  ]
 
  provisioner "local-exec" {
    command = "chrome http://${ aws_instance.instance.public_ip }"
}
}
