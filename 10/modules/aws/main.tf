locals {
  ip              = var.enabled ? aws_instance.webserver.private_ip : ""
  ip_bastion      = var.enabled ? aws_instance.bastion.public_ip : ""
  ip_loadbalancer = var.enabled ? aws_eip.elastic_ip.public_ip : ""
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.azs
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "fw_external_bastion" {
  name   = "${var.name}-fw_external_bastion"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "icmp"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    #cidr_blocks      = [module.vpc.vpc_cidr_block]
    #ipv6_cidr_blocks = [module.vpc.vpc_ipv6_cidr_block]
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #cidr_blocks      = [module.vpc.vpc_cidr_block]
    #ipv6_cidr_blocks = [module.vpc.vpc_ipv6_cidr_block]
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

resource "aws_security_group" "fw_external_loadbalancer" {
  name   = "${var.name}-fw_external_loadbalancer"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "icmp"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    #cidr_blocks      = [module.vpc.vpc_cidr_block]
    #ipv6_cidr_blocks = [module.vpc.vpc_ipv6_cidr_block]
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #cidr_blocks      = [module.vpc.vpc_cidr_block]
    #ipv6_cidr_blocks = [module.vpc.vpc_ipv6_cidr_block]
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "web"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    #cidr_blocks      = [module.vpc.vpc_cidr_block]
    #ipv6_cidr_blocks = [module.vpc.vpc_ipv6_cidr_block]
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

resource "aws_instance" "bastion" {
  ami                         = var.os_image
  instance_type               = var.os_size
  user_data                   = var.user_data
  subnet_id                   = module.vpc.public_subnets.0
  vpc_security_group_ids      = [aws_security_group.fw_external_bastion.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.name}-bastion"
  }
}

resource "aws_instance" "webserver" {
  ami                    = var.os_image
  instance_type          = var.os_size
  user_data              = var.user_data
  subnet_id              = module.vpc.public_subnets.0
  vpc_security_group_ids = [aws_security_group.fw_external_loadbalancer.id]

  tags = {
    Name = "${var.name}-webserver"
  }
}

resource "aws_eip" "elastic_ip" {}

resource "aws_lb" "loadbalancer" {
  name               = "${var.name}-loadbalancer"
  internal           = false
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id     = module.vpc.public_subnets.0
    allocation_id = aws_eip.elastic_ip.id
  }
}

resource "aws_lb_target_group" "http" {
  name        = "${var.name}-loadbalancer-http"
  vpc_id      = module.vpc.vpc_id
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

resource "aws_lb_target_group_attachment" "http" {
  target_group_arn = aws_lb_target_group.http.arn
  target_id        = aws_instance.webserver.id
  port             = 80
}

resource "null_resource" "ansible" {
  triggers = {
    id = aws_instance.webserver.id
  }

  connection {
    host                = local.ip
    type                = "ssh"
    user                = var.admin_user
    private_key         = file(pathexpand(var.private_key))
    bastion_host        = local.ip_bastion
    bastion_user        = var.admin_user
    bastion_private_key = file(pathexpand(var.private_key))
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]
  }

  provisioner "local-exec" {
    command = <<EOL
        export ANSIBLE_HOST_KEY_CHECKING=False;
        export ANSIBLE_SSH_COMMON_ARGS='-A -o ProxyCommand="ssh -oStrictHostKeyChecking=no -W %h:%p -i ${var.private_key} ${var.admin_user}@${local.ip_bastion}"'
        until nc -zv ${local.ip_bastion} 22; do sleep 10; done
        pgrep ssh-agent || eval $(ssh-agent) && ssh-add ${var.private_key}
        ansible-playbook -u ${var.admin_user} --private-key ${var.private_key} -i ${local.ip}, ansible/web-playbook.yaml
      EOL
  }
}
