resource "aws_iam_role" "app_role" {
  name = "demo-app-ec2-role"

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

  tags = {
    Name        = "demo-app-role"
    Environment = "production"
    Project     = "demo-app"
  }
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "demo-app-instance-profile"
  role = aws_iam_role.app_role.name
}

resource "aws_iam_policy" "app_policy" {
  name        = "demo-app-policy"
  description = "Policy for demo app instance permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "demo-app-policy"
    Environment = "production"
    Project     = "demo-app"
  }
}

resource "aws_iam_role_policy_attachment" "app_policy_attach" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.app_policy.arn
}
