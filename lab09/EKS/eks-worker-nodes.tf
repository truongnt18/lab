#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "nodegrp-iam" {
  name = "${var.node_group_name}-iam"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "nodegrp-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodegrp-iam.name
}

resource "aws_iam_role_policy_attachment" "nodegrp-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodegrp-iam.name
}

resource "aws_iam_role_policy_attachment" "nodegrp-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodegrp-iam.name
}

resource "aws_iam_role_policy_attachment" "nodegrp-AmazonElasticFileSystemClientFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"
  role       = aws_iam_role.nodegrp-iam.name
}

#resource "aws_iam_role_policy_attachment" "nodegrp-SendLogsToCloudWatch" {
#  policy_arn = "arn:aws:iam::${var.account_name}:policy/SendLogsToCloudWatch"
#  role       = aws_iam_role.nodegrp-iam.name
#}

#resource "aws_iam_role_policy_attachment" "nodegrp-iam-policy-json" {
#  policy_arn = "arn:aws:iam::${var.account_name}:policy/iam-policy-json"
#  role       = aws_iam_role.nodegrp-iam.name
#}

resource "aws_iam_role_policy_attachment" "nodegrp-AmazonSSMFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  role       = aws_iam_role.nodegrp-iam.name
}

#data "aws_subnet_ids" "private" {
#  vpc_id = var.vpc_id

#  tags = {
#    Tier = "Private"
  #  Tier = "Public"
#  }
#} 

resource "aws_eks_node_group" "cg_eks_nodegrp" {
  cluster_name    = aws_eks_cluster.cg_eks_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.nodegrp-iam.arn
  subnet_ids = [
   "subnet-05a61b003c6da715e",
   "subnet-0dc16c0e310ed07a2"
  ]
  instance_types  = ["t3.large"]
  disk_size	  = 20
  scaling_config {
    desired_size = 1
    max_size     = 4
    min_size     = 1
  }
  remote_access {
    ec2_ssh_key               = var.ssh_key
  #  source_security_group_ids = [sg-04e4a4744e4240b5e]
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodegrp-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodegrp-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodegrp-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.nodegrp-AmazonElasticFileSystemClientFullAccess,
#    aws_iam_role_policy_attachment.nodegrp-SendLogsToCloudWatch,
#    aws_iam_role_policy_attachment.nodegrp-iam-policy-json,
#    aws_iam_role_policy_attachment.nodegrp-cgai-sit-stream,
#    aws_iam_role_policy_attachment.nodegrp-eks-node-read-s3-cgai-keystores,
    aws_iam_role_policy_attachment.nodegrp-AmazonSSMFullAccess,
  ]
  tags = {
     "Name" = var.node_group_name,
     "Owner" = "cto",
     "Environment" = var.env,
     "BusinessUnit" = var.project-name,
     "ManagedBy" = "Terraform"
     "k8s.io/cluster-autoscaler/${var.project-name}-${var.env}" = "owned"
     "k8s.io/cluster-autoscaler/enabled" = "true"
  }
}
#}
