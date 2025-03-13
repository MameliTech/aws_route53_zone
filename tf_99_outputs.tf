#==================================================================
# route53-zone - outputs.tf
#==================================================================

#------------------------------------------------------------------
# Route 53 - Zone
#------------------------------------------------------------------
output "zone_id" {
  description = "O ID da Route 53 Hosted Zone."
  value       = aws_route53_zone.this.id
}

output "arn" {
  description = "O ARN da Route 53 Hosted Zone."
  value       = aws_route53_zone.this.arn
}

output "name_servers" {
  description = "A lista de servidores de nomes."
  value       = aws_route53_zone.this.name_servers
}

output "primary_name_server" {
  description = "O servidor de nomes do Route 53."
  value       = aws_route53_zone.this.primary_name_server
}


#------------------------------------------------------------------
# IAM Policy
#------------------------------------------------------------------
output "policy_map" {
  description = "Mapa com ARNs de politicas de acesso ('acao' : 'arn')."
  value = {
    "r53-zone_ro" : aws_iam_policy.r53-zone_ro.arn
    "r53-zone_op" : aws_iam_policy.r53-zone_op.arn
    "r53-zone_pu" : aws_iam_policy.r53-zone_pu.arn
  }
}
