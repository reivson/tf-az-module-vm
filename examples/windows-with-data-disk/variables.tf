variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "rg-vm-windows-example"
}

variable "location" {
  description = "Localização do Azure"
  type        = string
  default     = "East US"
}

variable "vm_name" {
  description = "Nome da Virtual Machine"
  type        = string
  default     = "vm-windows-example"
}

variable "vm_size" {
  description = "Tamanho da VM"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "Nome do usuário administrador"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "Senha do administrador"
  type        = string
  sensitive   = true
}

variable "create_public_ip" {
  description = "Criar IP público"
  type        = bool
  default     = true
}

variable "os_disk_size_gb" {
  description = "Tamanho do disco do SO em GB"
  type        = number
  default     = 128
}

variable "data_disk_size_gb" {
  description = "Tamanho do disco de dados em GB"
  type        = number
  default     = 100
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default = {
    Environment = "development"
    Project     = "terraform-module-example"
    Owner       = "DevOps Team"
    OS          = "Windows"
  }
}
