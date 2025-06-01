
resource "aws_iam_role" "ec2_secrets_manager_role" {
  name = "${var.week_prefix}-EC2SecretsManagerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "${var.week_prefix}-SecretsManagerAccessPolicy"
  description = "Policy to allow EC2 to access Secrets Manager and CloudWatch for YACE"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.secret_manager_arn
      },
      {
        Effect = "Allow"
        Action = [
          "tag:GetResources",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "iam:ListAccountAliases",
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "secrets_manager_attachment" {
  role       = aws_iam_role.ec2_secrets_manager_role.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}


resource "aws_iam_instance_profile" "access_secret_manager" {
  name = "${var.week_prefix}-EC2SecretsManagerInstanceProfile"
  role = aws_iam_role.ec2_secrets_manager_role.name
}
