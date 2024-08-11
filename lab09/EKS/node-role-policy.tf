resource "aws_iam_policy" "iam-policy" {
  name        = "iam-policy"
  description = "Policy for EKS Cluster"
  policy      = file("policies/iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "nodegrp-iam-policy" {
  policy_arn = "arn:aws:iam::${var.account_name}:policy/iam-policy"
  role       = aws_iam_role.nodegrp-iam.id
}

#### Creating Cluster Autoscaler Policy ####

resource "aws_iam_policy" "cluster_autoscaler" {
  name        = "cluster_autoscaler"
  description = "Policy for Cluster Autoscaler"
  policy      = file("policies/ca.json")
}

resource "aws_iam_role_policy_attachment" "nodegrp-cluster_autoscaler" {
  policy_arn = "arn:aws:iam::${var.account_name}:policy/cluster_autoscaler"
  role       = aws_iam_role.nodegrp-iam.id
}

resource "aws_iam_policy" "SendLogsToCloudWatch-cg" {
  name        = "Send-Logs-to-CloudWatch"
  description = "Policy for SendLogstoCloudWatch"
  policy      = file("policies/SendLogstoCloudWatch.json")
}

resource "aws_iam_role_policy_attachment" "nodegrp-SendLogstoCloudWatch" {
  policy_arn = "arn:aws:iam::${var.account_name}:policy/Send-Logs-to-CloudWatch"
  role       = aws_iam_role.nodegrp-iam.id
}



resource "aws_iam_policy" "ALBPolicy-cg" {
  name        = "Alb_policy"
  description = "Policy for ALB Ingress Controller"
  policy      = file("policies/alb-policy.json")
}

resource "aws_iam_role_policy_attachment" "nodegrp-ALBPolicy-cg" {
  policy_arn = "arn:aws:iam::${var.account_name}:policy/Alb_policy"
  role       = aws_iam_role.nodegrp-iam.id
}
