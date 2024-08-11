#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_iam_role" "cluster_iam" {
  name = "${var.project-name}-${var.env}-iam"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_iam.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster_iam.name
}

resource "aws_security_group" "cluster_sg" {
  name        = "${var.project-name}-${var.env}-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project-name}-${var.env}-sg"
  }
}

resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster_sg.id
  to_port           = 443
  type              = "ingress"
}

#data "aws_subnet_ids" "selected" {
#  vpc_id = var.vpc_id

#  tags = {
#    Tier = "Private",
#    Tier = "Public"
#  }
#} 


resource "aws_eks_cluster" "cg_eks_cluster" {
  name     = local.ClusterName
  version  = var.eks_version
 # for_each      = data.aws_subnet_ids.selected.ids
  role_arn = aws_iam_role.cluster_iam.arn
  enabled_cluster_log_types = ["audit", "scheduler", "authenticator", "controllerManager", "api"]

  vpc_config {
    security_group_ids = [aws_security_group.cluster_sg.id]
    subnet_ids = [ 
 	      "subnet-05a61b003c6da715e", 
        "subnet-0dc16c0e310ed07a2"
 ]

  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]
}
