
resource "aws_key_pair" "minikube-deploy-kp" {
  key_name = "${var.aws_key_name}"
  public_key = "${file(var.public_key_path)}"

}

resource "aws_instance" "kube-master" {
  ami = "${var.aws_ami_id}"
  instance_type = "${var.aws_instance_type}"
  key_name = "${var.aws_key_name}"
  tags {
    Name = "${var.aws_cluster_name}-master",
    Role = "master"
  }
  count = 1
  vpc_security_group_ids = ["${aws_security_group.master-sg.id}"]

  provisioner "remote-exec" {
   script = "./minikube.sh"
   connection {
    host        = "${aws_instance.minikube-master.public_ip}"
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)}"
    }
  }
}

