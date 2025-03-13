# AWS Route 53 Hosted Zone

![Provedor](https://img.shields.io/badge/provider-AWS-orange) ![Engine](https://img.shields.io/badge/engine-Route_53_Hosted_Zone-blueviolet) ![Versão](https://img.shields.io/badge/version-v.1.0.0-success) ![Coordenação](https://img.shields.io/badge/coord.-Mameli_Tech-informational)<br>

Módulo desenvolvido para o provisionamento de **AWS Route 53 Hosted Zone**.

Este módulo tem como objetivo criar um Route 53 Hosted Zone seguindo os padrões da Mameli Tech.

Serão criados os seguintes recursos:
1. **Route 53 Hosted Zone** com o nome do <span style="font-size: 12px;">`Domínio`</span>
2. **IAM Policy** com permissão ***Read-Only*** com o nome no padrão <span style="font-size: 12px;">`NomeDaAplicação-Ambiente-FunçãoDoRecurso-AccessToR53Zone_ro`</span>
3. **IAM Policy** com permissão ***Operator*** com o nome no padrão <span style="font-size: 12px;">`NomeDaAplicação-Ambiente-FunçãoDoRecurso-AccessToR53Zone_op`</span>
4. **IAM Policy** com permissão ***Power User*** com o nome no padrão <span style="font-size: 12px;">`NomeDaAplicação-Ambiente-FunçãoDoRecurso-AccessToR53Zone_pu`</span>
<br>

## Como utilizar?

### Passo 1

Precisamos configurar o Terraform para armazenar o estado dos recursos criados.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_01_backend.tf` com o conteúdo abaixo:

```hcl
#==================================================================
# backend.tf - Script de definicao do Backend
#==================================================================

terraform {
  backend "s3" {
    encrypt = true
  }
}
```

### Passo 2

Precisamos armazenar as definições de variáveis que serão utilizadas pelo Terraform.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_02_variables.tf` com o conteúdo a seguir.<br>
Caso exista, adicione o conteúdo abaixo no arquivo:

```hcl
#==================================================================
# variables.tf - Script de definicao de Variaveis
#==================================================================

#------------------------------------------------------------------
# Provider
#------------------------------------------------------------------
variable "account_region" {
  description = "Regiao onde os recursos serao alocados."
  type        = string
}


#------------------------------------------------------------------
# Resource Nomenclature & Tags
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
}

variable "rn_role" {
  description = "Funcao do recurso. Limitado a 8 caracteres."
  type        = string
}

variable "default_tags" {
  description = "TAGs padrao que serao adicionadas a todos os recursos."
  type        = map(string)
}


#------------------------------------------------------------------
# Route 53 Hosted Zone
#------------------------------------------------------------------
variable "route53-zone" {
  type = map(object({
    rn_role     = string
    domain_name = string
    comment     = string
    is_private  = bool
  }))
}
```

 ### Passo 3

Precisamos configurar informar o Terraform em qual região os recursos serão implementados.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_03_provider.tf` com o conteúdo abaixo:

```hcl
#==================================================================
# provider.tf - Script de definicao do Provider
#==================================================================

provider "aws" {
  region = var.account_region

  default_tags {
    tags = var.default_tags
  }
}
```

### Passo 4

O script abaixo será responsável por criar o Route 53.<br>
Crie um arquivo no padrão `tf_NN_route53-zone.tf` e adicione:

```hcl
#===================================================================
# route53-zone.tf - Script de chamada do modulo Route 53 Hosted Zone
#===================================================================

module "route53-zone" {
  source   = "git@github.com:MameliTech/aws_route53_zone.git"
  for_each = var.route53-zone

  rn_squad       = var.rn_squad
  rn_application = var.rn_application
  rn_environment = var.rn_environment
  rn_role        = each.value.rn_role
  domain_name    = each.value.domain_name
  comment        = each.value.comment
  is_private     = each.value.is_private
}
```

### Passo 5

O script abaixo será responsável por gerar os Outputs dos recursos criados.<br>
Crie um arquivo no padrão `tf_99_outputs.tf` e adicione:

```hcl
#==================================================================
# outputs.tf - Script para geracao de Outputs
#==================================================================

output "all_outputs" {
  description = "All outputs"
  value       = module.route53-zone
}
```

### Passo 6

Adicione uma pasta env com os arquivos `dev.tfvars`, `hml.tfvars` e `prd.tfvars`. Em cada um destes arquivos você irá informar os valores das variáveis que o módulo utiliza.

Segue um exemplo do conteúdo de um arquivo `tfvars`:

```hcl
#==================================================================
# <dev/hml/prd>.tfvars - Arquivo de definicao de Valores de Variaveis
#==================================================================

#------------------------------------------------------------------
# Provider
#------------------------------------------------------------------
account_region = "us-east-1"


#------------------------------------------------------------------
# Resource Nomenclature & Tags
#------------------------------------------------------------------
rn_squad       = "devops"
rn_application = "sap"
rn_environment = "dev"

default_tags = {
  "N_projeto" : "DevOps Lab"                                                            # Nome do projeto
  "N_ccusto_ti" : "Mameli-TI-2025"                                                      # Centro de Custo TI
  "N_ccusto_neg" : "Mameli-Business-2025"                                               # Centro de Custo Negocio
  "N_info" : "Para maiores informacoes procure a Mameli Tech - consultor@mameli.com.br" # Informacoes adicionais
  "T_funcao" : "Hosted Zone do Route 53"                                                # Funcao do recurso
  "T_versao" : "1.0"                                                                    # Versao de provisionamento do ambiente
  "T_backup" : "nao"                                                                    # Descritivo se sera realizado backup automaticamente dos recursos provisionados
}


#------------------------------------------------------------------
# Route 53 Hosted Zone
#------------------------------------------------------------------
route53-zone = {
  teste = {
    rn_role     = "testecom"
    domain_name = "teste.com"
    comment     = "Dominio para acesso a aplicacao Teste"
    is_private  = false
  }
}
```

<br>

## Requisitos

| Nome | Versão |
|------|---------|
| [Terraform]() | >= 1.5.7 |
| [AWS]() | >= 5.42.0 |

<br>

## Recursos

| Nome | Tipo |
|------|------|
| [aws_iam_policy]() | resource |
| [aws_route53_zone]() | resource |

<br>

## Entradas do módulo

 A tabela a seguir segue a ordem presente no código.

| Nome | Descrição | Tipo | Default | Obrigatório |
|------|-----------|------|---------|:-----------:|
| [rn_squad]() | Nome da squad. Limitado a 8 caracteres. | `string` | `null` | sim |
| [rn_application]() | Nome da aplicação. Limitado a 8 caracteres. | `string` | `null` | sim |
| [rn_environment]() | Acrônimo do ambiente (dev/hml/prd/devops). Limitado a 6 caracteres. | `string` | `null` | sim |
| [rn_role]() | Função do recurso. Limitado a 8 caracteres. | `string` | `null` | sim |
| [domain_name]() | Nome do dominio para a Hosted Zone. | `string` | `null` | sim |
| [comment]() | Comentário/Descrição para a Hosted Zone. O padrão é 'Managed by Terraform'. | `string` | `Managed by Terraform"
| [is_private]() | Indica se a Hosted Zone é privada (true) ou pública (false). | `bool` | `null` | sim |

<br><br><hr>

<div align="right">

<strong> Data da última versão: &emsp; 09/03/2025 </strong>

</div>
