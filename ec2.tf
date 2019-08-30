
resource "aws_key_pair" "mediawiki-key" {
  key_name   = "${var.aws_key_name}"
  public_key = "${file(var.public_key_path)}"

}


#Fetching the Ami for creating instances

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "kube-master" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.aws_instance_type}"
  key_name                    = "${var.aws_key_name}"
  subnet_id                   = "${aws_subnet.public_subnet1.id}"
  associate_public_ip_address = "true"
  depends_on                  = ["aws_instance.kube-worker1", "aws_instance.kube-worker2"]
  tags = {
    Name = "kube-master",
    Role = "master"
  }

  vpc_security_group_ids = ["${aws_security_group.master-sg.id}"]

  provisioner "file" {
    source      = "./kubeadm.sh"
    destination = "/home/ubuntu/kubeadm.sh"

    connection {
      host        = "${aws_instance.kube-master.public_ip}"
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.private_key_path)}"
    }
  }

  provisioner "file" {
    source      = "./kube-manifest.yaml"
    destination = "/home/ubuntu/kube-manifest.yaml"

    connection {
      host        = "${aws_instance.kube-master.public_ip}"
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.private_key_path)}"
    }
  }

  provisioner "file" {
    source      = "~/.ssh/id_rsa"
    destination = "~/.ssh/id_rsa"

    connection {
      host        = "${aws_instance.kube-master.public_ip}"
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.private_key_path)}"
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/kubeadm.sh",
      "sudo chmod 400 ~/.ssh/id_rsa",
      "sudo sh /home/ubuntu/kubeadm.sh",
      "mkdir -p /home/ubuntu/.kube",
      "sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config",
      "sudo chown -R ubuntu:ubuntu  /home/ubuntu/",
      "sudo kubeadm token create --print-join-command > /home/ubuntu/join-command.sh",
      "sed -i '1 i #!/bin/bash' /home/ubuntu/join-command.sh",
      "sudo chmod +x /home/ubuntu/join-command.sh",
			"cat /home/ubuntu/join-command.sh |  ssh  -t -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@${aws_instance.kube-worker2.private_ip} sudo /bin/bash",
			"cat /home/ubuntu/join-command.sh |  ssh  -t -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@${aws_instance.kube-worker1.private_ip} sudo /bin/bash",
			"kubectl create -f /home/ubuntu/kube-manifest.yaml",
    ]

    connection {
      host        = "${aws_instance.kube-master.public_ip}"
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.private_key_path)}"
    }

  }
}




resource "aws_instance" "kube-worker1" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.aws_instance_type}"
  key_name                    = "${var.aws_key_name}"
  subnet_id                   = "${aws_subnet.public_subnet1.id}"
  associate_public_ip_address = "true"
  depends_on                  = ["aws_instance.kube-worker2"]
  #private_ip	=	"10.0.2.23"
  tags = {
    Name = "worker1",
    Role = "worker"
  }

  vpc_security_group_ids = ["${aws_security_group.master-sg.id}"]

  provisioner "file" {
    source      = "./worker.sh"
    destination = "/home/ubuntu/worker.sh"

    connection {
      host        = "${aws_instance.kube-worker1.public_ip}"
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.private_key_path)}"
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/worker.sh",
      "sudo sh /home/ubuntu/worker.sh",
    ]
    connection {
      host        = "${aws_instance.kube-worker1.public_ip}"
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.private_key_path)}"
    }

  }

}


resource "aws_instance" "kube-worker2" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.aws_instance_type}"
  key_name      = "${var.aws_key_name}"
  subnet_id     = "${aws_subnet.public_subnet1.id}"
  #	private_ip	=	"10.0.3.23"
  associate_public_ip_address = "true"
  tags = {
    Name = "worker2",
    Role = "worker"
  }

  vpc_security_group_ids = ["${aws_security_group.master-sg.id}"]

  provisioner "file" {
    source      = "./worker.sh"
    destination = "/home/ubuntu/worker.sh"

    connection {
      host        = "${aws_instance.kube-worker2.public_ip}"
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.private_key_path)}"
    }
  }


  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/worker.sh",
      "sudo sh /home/ubuntu/worker.sh",
    ]
    connection {
      host        = "${aws_instance.kube-worker2.public_ip}"
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.private_key_path)}"
    }

  }

}
