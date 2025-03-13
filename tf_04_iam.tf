#==================================================================
# route53-zone - iam.tf
#==================================================================

#------------------------------------------------------------------
# IAM Policy - Route 53 Hosted Zone - Read-Only
#------------------------------------------------------------------
resource "aws_iam_policy" "r53-zone_ro" {
  name = local.iam_r53-zone_ro

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ReadOnly",
        "Effect" : "Allow",
        "Action" : [
          "route53:GetDNSSEC",
          "route53:GetHostedZone",
          "route53:ListHostedZones",
          "route53:ListHostedZonesByName",
          "route53:ListHostedZonesByVPC",
          "route53:ListTagsForResource",
          "route53:ListTagsForResources",
          "route53:GetChange",
          "route53:ListResourceRecordSets",
          "route53:ListCidrBlocks"
        ],
        "Resource" : aws_route53_zone.this.arn,
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "true"
          }
        }
      }
    ]
  })

  tags = { "Name" : local.iam_r53-zone_ro }
}


#------------------------------------------------------------------
# IAM Policy - Route 53 Hosted Zone - Operator
#------------------------------------------------------------------
resource "aws_iam_policy" "r53-zone_op" {
  name = local.iam_r53-zone_op

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Operator",
        "Effect" : "Allow",
        "Action" : [
          "route53:GetDNSSEC",
          "route53:GetHostedZone",
          "route53:ListHostedZones",
          "route53:ListHostedZonesByName",
          "route53:ListHostedZonesByVPC",
          "route53:ListTagsForResource",
          "route53:ListTagsForResources",
          "route53:GetChange",
          "route53:ListResourceRecordSets",
          "route53:ListCidrBlocks",
          "route53:TestDNSAnswer"
        ],
        "Resource" : aws_route53_zone.this.arn,
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "true"
          }
        }
      }
    ]
  })

  tags = { "Name" : local.iam_r53-zone_op }
}


#------------------------------------------------------------------
# IAM Policy - Route 53 Hosted Zone - Power User
#------------------------------------------------------------------
resource "aws_iam_policy" "r53-zone_pu" {
  name = local.iam_r53-zone_pu

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PowerUser",
        "Effect" : "Allow",
        "Action" : [
          "route53:GetDNSSEC",
          "route53:GetHostedZone",
          "route53:ListHostedZones",
          "route53:ListHostedZonesByName",
          "route53:ListHostedZonesByVPC",
          "route53:ListTagsForResource",
          "route53:ListTagsForResources",
          "route53:GetChange",
          "route53:ListResourceRecordSets",
          "route53:ListCidrBlocks",
          "route53:TestDNSAnswer"
        ],
        "Resource" : aws_route53_zone.this.arn,
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "true"
          }
        }
      }
    ]
  })

  tags = { "Name" : local.iam_r53-zone_pu }
}
