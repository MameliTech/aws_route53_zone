#==================================================================
# route53-zone - resource-names.tf
#==================================================================

locals {
  iam_r53-zone_ro = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-AccessToR53Zone_ro"
  iam_r53-zone_op = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-AccessToR53Zone_op"
  iam_r53-zone_pu = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-AccessToR53Zone_pu"
}
