data "aws_route53_zone" "zone" {
  provider = aws.dns
  name     = "${var.domain}."
}

data "aws_ami" "minecraft" {
  most_recent = true             # We only want the latest version
  owners      = ["self"]         # AMIs that live in this Account only
  name_regex  = "minecraft \\d*" # Regular Expression to filter the right AMI name
}

output "ami" {
  value = data.aws_ami.minecraft.id
}
