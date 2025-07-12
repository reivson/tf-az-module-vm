variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "rg-vm-linux-example"
}

variable "location" {
  description = "Localização do Azure"
  type        = string
  default     = "East US"
}

variable "vm_name" {
  description = "Nome da Virtual Machine"
  type        = string
  default     = "vm-linux-example"
}

variable "vm_size" {
  description = "Tamanho da VM"
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
  description = "Criar IP público"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default = {
    Environment = "development"
    Project     = "terraform-module-example"
    Owner       = "DevOps Team"
  }
}
