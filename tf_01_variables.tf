#==================================================================
# route53-zone - variables.tf
#==================================================================

#------------------------------------------------------------------
# Resource Nomenclature
#------------------------------------------------------------------
variable "rn_squad" {
  description = "Nome da squad. Limitado a 8 caracteres."
  type        = string
}

variable "rn_application" {
  description = "Nome da aplicacao. Limitado a 8 caracteres."
  type        = string
}

variable "rn_environment" {
  description = "Acronimo do ambiente (dev/hml/prd/devops). Limitado a 6 caracteres."
  type        = string
  validation {
    condition     = var.rn_environment == "dev" || var.rn_environment == "hml" || var.rn_environment == "prd" || var.rn_environment == "devops"
    error_message = "Valor invalido. Deve ser 'dev', 'hml', 'prd' ou 'devops'."
  }
}

variable "rn_role" {
  description = "Funcao do recurso. Limitado a 8 caracteres."
  type        = string
}


#------------------------------------------------------------------
# Route 53 Hosted Zone
#------------------------------------------------------------------
variable "domain_name" {
  description = "O nome do dominio para a Hosted Zone."
  type        = string
}

variable "comment" {
  description = "Comentario/Descricao para a Hosted Zone. O padrao e 'Managed by Terraform'."
  type        = string
  default     = "Managed by Terraform"
}

variable "is_private" {
  description = "Indica se a Hosted Zone e privada (true) ou publica (false)."
  type        = bool
}
