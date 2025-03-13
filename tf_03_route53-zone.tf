#==================================================================
# route53-zone.tf
#==================================================================

resource "aws_route53_zone" "this" {
  name          = var.domain_name
  comment       = var.comment
  force_destroy = true

  dynamic "vpc" {
    for_each = var.is_private ? [1] : []
    content {
      vpc_id = data.aws_vpc.this.id
    }
  }

  tags = { "Name" : var.domain_name }
}
