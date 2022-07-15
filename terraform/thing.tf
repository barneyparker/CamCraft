resource "aws_launch_template" "minecraft" {
  name_prefix            = "minecraft"
  image_id               = data.aws_ami.minecraft.id
  instance_type          = "t4g.small"
  vpc_security_group_ids = [aws_security_group.minecraft.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.minecraft_profile.name
  }
  user_data = filebase64("${path.module}/user-data.sh")
}

resource "aws_autoscaling_group" "minecraft" {
  name               = "minecraftgroup"
  availability_zones = ["eu-west-1a", "eu-west-1c", "eu-west-1c"]

  desired_capacity = 0
  max_size         = 1
  min_size         = 0

  launch_template {
    id      = aws_launch_template.minecraft.id
    version = "$Latest"
  }
}

data "aws_vpc" "vpc" {
  id = "vpc-0bb13d1eda194ab31"
}

resource "aws_security_group" "minecraft" {
  name        = "minecraft"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minecraft"
  }
}

resource "aws_iam_instance_profile" "minecraft_profile" {
  name = "minecraft_profile"
  role = aws_iam_role.minecraft_role.name
}

resource "aws_iam_role" "minecraft_role" {
  name = "minecraft_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "minecraft-attach" {
  role       = aws_iam_role.minecraft_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "minecraft_policy" {
  name = "permissions"
  role = aws_iam_role.minecraft_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "route53:ChangeResourceRecordSets",
          "s3:List*",
          "s3:PutObject*",
          "s3:GetObject*",
          "autoscaling:SetDesiredCapacity",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}