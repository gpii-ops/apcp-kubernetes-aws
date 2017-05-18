output "cluster_name" {
  value = "k8s-dev.gpii.net"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-k8s-dev-gpii-net.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-k8s-dev-gpii-net.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-k8s-dev-gpii-net.name}"
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-k8s-dev-gpii-net.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.us-east-1a-k8s-dev-gpii-net.id}", "${aws_subnet.us-east-1b-k8s-dev-gpii-net.id}", "${aws_subnet.us-east-1c-k8s-dev-gpii-net.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-k8s-dev-gpii-net.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-k8s-dev-gpii-net.name}"
}

output "region" {
  value = "us-east-1"
}

output "vpc_id" {
  value = "${aws_vpc.k8s-dev-gpii-net.id}"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_autoscaling_group" "master-us-east-1a-masters-k8s-dev-gpii-net" {
  name                 = "master-us-east-1a.masters.k8s-dev.gpii.net"
  launch_configuration = "${aws_launch_configuration.master-us-east-1a-masters-k8s-dev-gpii-net.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-east-1a-k8s-dev-gpii-net.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "k8s-dev.gpii.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-east-1a.masters.k8s-dev.gpii.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "master-us-east-1b-masters-k8s-dev-gpii-net" {
  name                 = "master-us-east-1b.masters.k8s-dev.gpii.net"
  launch_configuration = "${aws_launch_configuration.master-us-east-1b-masters-k8s-dev-gpii-net.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-east-1b-k8s-dev-gpii-net.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "k8s-dev.gpii.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-east-1b.masters.k8s-dev.gpii.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "master-us-east-1c-masters-k8s-dev-gpii-net" {
  name                 = "master-us-east-1c.masters.k8s-dev.gpii.net"
  launch_configuration = "${aws_launch_configuration.master-us-east-1c-masters-k8s-dev-gpii-net.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-east-1c-k8s-dev-gpii-net.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "k8s-dev.gpii.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-east-1c.masters.k8s-dev.gpii.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "nodes-k8s-dev-gpii-net" {
  name                 = "nodes.k8s-dev.gpii.net"
  launch_configuration = "${aws_launch_configuration.nodes-k8s-dev-gpii-net.id}"
  max_size             = 3
  min_size             = 3
  vpc_zone_identifier  = ["${aws_subnet.us-east-1a-k8s-dev-gpii-net.id}", "${aws_subnet.us-east-1b-k8s-dev-gpii-net.id}", "${aws_subnet.us-east-1c-k8s-dev-gpii-net.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "k8s-dev.gpii.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.k8s-dev.gpii.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_ebs_volume" "a-etcd-events-k8s-dev-gpii-net" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "k8s-dev.gpii.net"
    Name                 = "a.etcd-events.k8s-dev.gpii.net"
    "k8s.io/etcd/events" = "a/a,b,c"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "a-etcd-main-k8s-dev-gpii-net" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "k8s-dev.gpii.net"
    Name                 = "a.etcd-main.k8s-dev.gpii.net"
    "k8s.io/etcd/main"   = "a/a,b,c"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "b-etcd-events-k8s-dev-gpii-net" {
  availability_zone = "us-east-1b"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "k8s-dev.gpii.net"
    Name                 = "b.etcd-events.k8s-dev.gpii.net"
    "k8s.io/etcd/events" = "b/a,b,c"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "b-etcd-main-k8s-dev-gpii-net" {
  availability_zone = "us-east-1b"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "k8s-dev.gpii.net"
    Name                 = "b.etcd-main.k8s-dev.gpii.net"
    "k8s.io/etcd/main"   = "b/a,b,c"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "c-etcd-events-k8s-dev-gpii-net" {
  availability_zone = "us-east-1c"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "k8s-dev.gpii.net"
    Name                 = "c.etcd-events.k8s-dev.gpii.net"
    "k8s.io/etcd/events" = "c/a,b,c"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "c-etcd-main-k8s-dev-gpii-net" {
  availability_zone = "us-east-1c"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "k8s-dev.gpii.net"
    Name                 = "c.etcd-main.k8s-dev.gpii.net"
    "k8s.io/etcd/main"   = "c/a,b,c"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_iam_instance_profile" "masters-k8s-dev-gpii-net" {
  name = "masters.k8s-dev.gpii.net"
  role = "${aws_iam_role.masters-k8s-dev-gpii-net.name}"
}

resource "aws_iam_instance_profile" "nodes-k8s-dev-gpii-net" {
  name = "nodes.k8s-dev.gpii.net"
  role = "${aws_iam_role.nodes-k8s-dev-gpii-net.name}"
}

resource "aws_iam_role" "masters-k8s-dev-gpii-net" {
  name               = "masters.k8s-dev.gpii.net"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.k8s-dev.gpii.net_policy")}"
}

resource "aws_iam_role" "nodes-k8s-dev-gpii-net" {
  name               = "nodes.k8s-dev.gpii.net"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.k8s-dev.gpii.net_policy")}"
}

resource "aws_iam_role_policy" "masters-k8s-dev-gpii-net" {
  name   = "masters.k8s-dev.gpii.net"
  role   = "${aws_iam_role.masters-k8s-dev-gpii-net.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.k8s-dev.gpii.net_policy")}"
}

resource "aws_iam_role_policy" "nodes-k8s-dev-gpii-net" {
  name   = "nodes.k8s-dev.gpii.net"
  role   = "${aws_iam_role.nodes-k8s-dev-gpii-net.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.k8s-dev.gpii.net_policy")}"
}

resource "aws_internet_gateway" "k8s-dev-gpii-net" {
  vpc_id = "${aws_vpc.k8s-dev-gpii-net.id}"

  tags = {
    KubernetesCluster = "k8s-dev.gpii.net"
    Name              = "k8s-dev.gpii.net"
  }
}

resource "aws_key_pair" "kubernetes-k8s-dev-gpii-net-39578d6325827aaba389bc7dda2d2c76" {
  key_name   = "kubernetes.k8s-dev.gpii.net-39:57:8d:63:25:82:7a:ab:a3:89:bc:7d:da:2d:2c:76"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.k8s-dev.gpii.net-39578d6325827aaba389bc7dda2d2c76_public_key")}"
}

resource "aws_launch_configuration" "master-us-east-1a-masters-k8s-dev-gpii-net" {
  name_prefix                 = "master-us-east-1a.masters.k8s-dev.gpii.net-"
  image_id                    = "ami-b2137ea4"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-k8s-dev-gpii-net-39578d6325827aaba389bc7dda2d2c76.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-k8s-dev-gpii-net.id}"
  security_groups             = ["${aws_security_group.masters-k8s-dev-gpii-net.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-east-1a.masters.k8s-dev.gpii.net_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "master-us-east-1b-masters-k8s-dev-gpii-net" {
  name_prefix                 = "master-us-east-1b.masters.k8s-dev.gpii.net-"
  image_id                    = "ami-b2137ea4"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-k8s-dev-gpii-net-39578d6325827aaba389bc7dda2d2c76.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-k8s-dev-gpii-net.id}"
  security_groups             = ["${aws_security_group.masters-k8s-dev-gpii-net.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-east-1b.masters.k8s-dev.gpii.net_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "master-us-east-1c-masters-k8s-dev-gpii-net" {
  name_prefix                 = "master-us-east-1c.masters.k8s-dev.gpii.net-"
  image_id                    = "ami-b2137ea4"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-k8s-dev-gpii-net-39578d6325827aaba389bc7dda2d2c76.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-k8s-dev-gpii-net.id}"
  security_groups             = ["${aws_security_group.masters-k8s-dev-gpii-net.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-east-1c.masters.k8s-dev.gpii.net_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "nodes-k8s-dev-gpii-net" {
  name_prefix                 = "nodes.k8s-dev.gpii.net-"
  image_id                    = "ami-b2137ea4"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-k8s-dev-gpii-net-39578d6325827aaba389bc7dda2d2c76.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-k8s-dev-gpii-net.id}"
  security_groups             = ["${aws_security_group.nodes-k8s-dev-gpii-net.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.k8s-dev.gpii.net_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.k8s-dev-gpii-net.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.k8s-dev-gpii-net.id}"
}

resource "aws_route_table" "k8s-dev-gpii-net" {
  vpc_id = "${aws_vpc.k8s-dev-gpii-net.id}"

  tags = {
    KubernetesCluster = "k8s-dev.gpii.net"
    Name              = "k8s-dev.gpii.net"
  }
}

resource "aws_route_table_association" "us-east-1a-k8s-dev-gpii-net" {
  subnet_id      = "${aws_subnet.us-east-1a-k8s-dev-gpii-net.id}"
  route_table_id = "${aws_route_table.k8s-dev-gpii-net.id}"
}

resource "aws_route_table_association" "us-east-1b-k8s-dev-gpii-net" {
  subnet_id      = "${aws_subnet.us-east-1b-k8s-dev-gpii-net.id}"
  route_table_id = "${aws_route_table.k8s-dev-gpii-net.id}"
}

resource "aws_route_table_association" "us-east-1c-k8s-dev-gpii-net" {
  subnet_id      = "${aws_subnet.us-east-1c-k8s-dev-gpii-net.id}"
  route_table_id = "${aws_route_table.k8s-dev-gpii-net.id}"
}

resource "aws_security_group" "masters-k8s-dev-gpii-net" {
  name        = "masters.k8s-dev.gpii.net"
  vpc_id      = "${aws_vpc.k8s-dev-gpii-net.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster = "k8s-dev.gpii.net"
    Name              = "masters.k8s-dev.gpii.net"
  }
}

resource "aws_security_group" "nodes-k8s-dev-gpii-net" {
  name        = "nodes.k8s-dev.gpii.net"
  vpc_id      = "${aws_vpc.k8s-dev-gpii-net.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster = "k8s-dev.gpii.net"
    Name              = "nodes.k8s-dev.gpii.net"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-dev-gpii-net.id}"
  source_security_group_id = "${aws_security_group.masters-k8s-dev-gpii-net.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-k8s-dev-gpii-net.id}"
  source_security_group_id = "${aws_security_group.masters-k8s-dev-gpii-net.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-k8s-dev-gpii-net.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-dev-gpii-net.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-k8s-dev-gpii-net.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-k8s-dev-gpii-net.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-k8s-dev-gpii-net.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-dev-gpii-net.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-dev-gpii-net.id}"
  from_port                = 1
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-dev-gpii-net.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-dev-gpii-net.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-dev-gpii-net.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-dev-gpii-net.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-k8s-dev-gpii-net.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-k8s-dev-gpii-net.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "us-east-1a-k8s-dev-gpii-net" {
  vpc_id            = "${aws_vpc.k8s-dev-gpii-net.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "us-east-1a"

  tags = {
    KubernetesCluster                        = "k8s-dev.gpii.net"
    Name                                     = "us-east-1a.k8s-dev.gpii.net"
    "kubernetes.io/cluster/k8s-dev.gpii.net" = "owned"
  }
}

resource "aws_subnet" "us-east-1b-k8s-dev-gpii-net" {
  vpc_id            = "${aws_vpc.k8s-dev-gpii-net.id}"
  cidr_block        = "172.20.64.0/19"
  availability_zone = "us-east-1b"

  tags = {
    KubernetesCluster                        = "k8s-dev.gpii.net"
    Name                                     = "us-east-1b.k8s-dev.gpii.net"
    "kubernetes.io/cluster/k8s-dev.gpii.net" = "owned"
  }
}

resource "aws_subnet" "us-east-1c-k8s-dev-gpii-net" {
  vpc_id            = "${aws_vpc.k8s-dev-gpii-net.id}"
  cidr_block        = "172.20.96.0/19"
  availability_zone = "us-east-1c"

  tags = {
    KubernetesCluster                        = "k8s-dev.gpii.net"
    Name                                     = "us-east-1c.k8s-dev.gpii.net"
    "kubernetes.io/cluster/k8s-dev.gpii.net" = "owned"
  }
}

resource "aws_vpc" "k8s-dev-gpii-net" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                        = "k8s-dev.gpii.net"
    Name                                     = "k8s-dev.gpii.net"
    "kubernetes.io/cluster/k8s-dev.gpii.net" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "k8s-dev-gpii-net" {
  domain_name         = "ec2.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster = "k8s-dev.gpii.net"
    Name              = "k8s-dev.gpii.net"
  }
}

resource "aws_vpc_dhcp_options_association" "k8s-dev-gpii-net" {
  vpc_id          = "${aws_vpc.k8s-dev-gpii-net.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.k8s-dev-gpii-net.id}"
}

terraform = {
  required_version = ">= 0.9.3"
}
