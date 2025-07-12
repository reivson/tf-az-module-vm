variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "rg-linux-distributions"
}

variable "location" {
  description = "Localização do Azure"
  type        = string
  default     = "East US"
}

variable "base_name" {
  description = "Nome base para os recursos"
  type        = string
  default     = "vm-distro"
}

variable "vm_size" {
  description = "Tamanho das VMs"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Nome do usuário administrador"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "Chave SSH pública"
  type        = string
  default     = null
}

variable "admin_password" {
  description = "Senha do administrador (alternativa ao SSH)"
  type        = string
  default     = null
  sensitive   = true
}

variable "create_public_ip" {
  description = "Criar IP público para as VMs"
  type        = bool
  default     = true
}

# Controles para criar cada distribuição
variable "create_ubuntu" {
  description = "Criar VM Ubuntu"
  type        = bool
  default     = true
}

variable "create_centos" {
  description = "Criar VM CentOS"
  type        = bool
  default     = false
}

variable "create_rhel" {
  description = "Criar VM Red Hat Enterprise Linux"
  type        = bool
  default     = false
}

variable "create_oracle" {
  description = "Criar VM Oracle Linux"
  type        = bool
  default     = false
}

variable "create_suse" {
  description = "Criar VM SUSE Linux Enterprise Server"
  type        = bool
  default     = false
}

variable "create_rocky" {
  description = "Criar VM Rocky Linux"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default = {
    Environment = "development"
    Project     = "linux-distributions-test"
    Owner       = "DevOps Team"
    Purpose     = "Testing Multiple Linux Distributions"
  }
}
