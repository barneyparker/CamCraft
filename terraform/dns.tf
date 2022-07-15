resource "aws_route53_zone" "zone" {
  name = "minecraft.${var.domain}"
}

resource "aws_route53_record" "subdomain" {
  provider = aws.dns

  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "minecraft"
  type    = "NS"
  ttl     = 30
  records = aws_route53_zone.zone.name_servers
}