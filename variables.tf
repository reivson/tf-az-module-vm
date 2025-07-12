# ==============================================================================
# REQUIRED VARIABLES
# ==============================================================================

variable "resource_group_name" {
  description = "Nome do Resource Group onde os recursos serão criados"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "O nome do Resource Group não pode estar vazio."
  }
}

variable "location" {
  description = "Localização do Azure onde os recursos serão criados"
  type        = string

  validation {
    condition = contains([
      "eastus", "eastus2", "westus", "westus2", "westus3", "centralus", "northcentralus", "southcentralus",
      "westcentralus", "canadacentral", "canadaeast", "brazilsouth", "northeurope", "westeurope",
      "uksouth", "ukwest", "francecentral", "germanywestcentral", "switzerlandnorth", "norwayeast",
      "southeastasia", "eastasia", "australiaeast", "australiasoutheast", "centralindia", "southindia",
      "japaneast", "japanwest", "koreacentral", "southafricanorth"
    ], var.location)
    error_message = "Localização do Azure inválida."
  }
}

variable "vm_name" {
  description = "Nome da Virtual Machine"
  type        = string

  validation {
    condition     = length(var.vm_name) >= 1 && length(var.vm_name) <= 64
    error_message = "O nome da VM deve ter entre 1 e 64 caracteres."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.vm_name))
    error_message = "O nome da VM pode conter apenas letras, números e hífens."
  }
}

variable "subnet_id" {
  description = "ID da subnet onde a VM será criada"
  type        = string

  validation {
    condition     = length(var.subnet_id) > 0
    error_message = "O ID da subnet não pode estar vazio."
  }
}

variable "admin_username" {
  description = "Nome do usuário administrador da VM"
  type        = string

  validation {
    condition     = length(var.admin_username) >= 1 && length(var.admin_username) <= 20
    error_message = "O nome de usuário deve ter entre 1 e 20 caracteres."
  }

  validation {
    condition     = !contains(["administrator", "admin", "user", "user1", "test", "user2", "test1", "user3", "admin1", "1", "123", "a", "actuser", "adm", "admin2", "aspnet", "backup", "console", "david", "guest", "john", "owner", "root", "server", "sql", "support", "support_388945a0", "sys", "test2", "test3", "user4", "user5"], lower(var.admin_username))
    error_message = "Nome de usuário não pode ser um nome reservado."
  }
}

# ==============================================================================
# OPTIONAL VARIABLES - VM Configuration
# ==============================================================================

variable "vm_size" {
  description = "Tamanho da Virtual Machine"
  type        = string
  default     = "Standard_B2s"

  validation {
    condition = contains([
      "Standard_B1s", "Standard_B1ms", "Standard_B2s", "Standard_B2ms", "Standard_B4ms", "Standard_B8ms", "Standard_B12ms", "Standard_B16ms", "Standard_B20ms",
      "Standard_D2s_v3", "Standard_D4s_v3", "Standard_D8s_v3", "Standard_D16s_v3", "Standard_D32s_v3", "Standard_D48s_v3", "Standard_D64s_v3",
      "Standard_D2s_v4", "Standard_D4s_v4", "Standard_D8s_v4", "Standard_D16s_v4", "Standard_D32s_v4", "Standard_D48s_v4", "Standard_D64s_v4",
      "Standard_E2s_v3", "Standard_E4s_v3", "Standard_E8s_v3", "Standard_E16s_v3", "Standard_E32s_v3", "Standard_E48s_v3", "Standard_E64s_v3"
    ], var.vm_size)
    error_message = "Tamanho de VM inválido. Use um dos tamanhos suportados."
  }
}

variable "os_type" {
  description = "Tipo do sistema operacional (linux ou windows)"
  type        = string
  default     = "linux"

  validation {
    condition     = contains(["linux", "windows"], var.os_type)
    error_message = "Tipo de SO deve ser 'linux' ou 'windows'."
  }
}

variable "linux_distribution" {
  description = "Distribuição Linux (apenas quando os_type = 'linux')"
  type        = string
  default     = "ubuntu"

  validation {
    condition = contains([
      "ubuntu", "centos", "rhel", "oracle", "suse", "debian", "rocky", "alma"
    ], var.linux_distribution)
    error_message = "Distribuição Linux deve ser: ubuntu, centos, rhel, oracle, suse, debian, rocky, ou alma."
  }
}

variable "os_version" {
  description = "Versão do sistema operacional. Para Linux, use versões específicas da distribuição (ex: '20.04-LTS' para Ubuntu, '8' para CentOS/RHEL, '15-SP3' para SUSE)"
  type        = string
  default     = "20.04-LTS"
}

variable "admin_password" {
  description = "Senha do administrador (obrigatória para Windows, opcional para Linux com SSH key)"
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition = var.admin_password == null || (
      length(var.admin_password) >= 12 &&
      length(var.admin_password) <= 123 &&
      can(regex("[A-Z]", var.admin_password)) &&
      can(regex("[a-z]", var.admin_password)) &&
      can(regex("[0-9]", var.admin_password)) &&
      can(regex("[^A-Za-z0-9]", var.admin_password))
    )
    error_message = "A senha deve ter entre 12-123 caracteres e conter pelo menos: 1 maiúscula, 1 minúscula, 1 número e 1 caractere especial."
  }
}

variable "ssh_public_key" {
  description = "Chave SSH pública para acesso à VM Linux"
  type        = string
  default     = null
}

variable "disable_password_authentication" {
  description = "Desabilitar autenticação por senha (apenas para Linux com SSH key)"
  type        = bool
  default     = true
}

# ==============================================================================
# OPTIONAL VARIABLES - Network Configuration
# ==============================================================================

variable "create_public_ip" {
  description = "Criar um IP público para a VM"
  type        = bool
  default     = false
}

variable "public_ip_allocation_method" {
  description = "Método de alocação do IP público"
  type        = string
  default     = "Static"

  validation {
    condition     = contains(["Static", "Dynamic"], var.public_ip_allocation_method)
    error_message = "Método de alocação deve ser 'Static' ou 'Dynamic'."
  }
}

variable "public_ip_sku" {
  description = "SKU do IP público"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.public_ip_sku)
    error_message = "SKU deve ser 'Basic' ou 'Standard'."
  }
}

variable "nsg_rules" {
  description = "Lista de regras do Network Security Group"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

# ==============================================================================
# OPTIONAL VARIABLES - Storage Configuration
# ==============================================================================

variable "os_disk_caching" {
  description = "Tipo de cache do disco do SO"
  type        = string
  default     = "ReadWrite"

  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.os_disk_caching)
    error_message = "Cache deve ser 'None', 'ReadOnly' ou 'ReadWrite'."
  }
}

variable "os_disk_storage_account_type" {
  description = "Tipo de storage account do disco do SO"
  type        = string
  default     = "Premium_LRS"

  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS"], var.os_disk_storage_account_type)
    error_message = "Tipo de storage deve ser 'Standard_LRS', 'StandardSSD_LRS' ou 'Premium_LRS'."
  }
}

variable "os_disk_size_gb" {
  description = "Tamanho do disco do SO em GB"
  type        = number
  default     = null

  validation {
    condition     = var.os_disk_size_gb == null ? true : (var.os_disk_size_gb >= 30 && var.os_disk_size_gb <= 4095)
    error_message = "Tamanho do disco deve estar entre 30 e 4095 GB."
  }
}

variable "data_disks" {
  description = "Lista de discos de dados adicionais"
  type = list(object({
    name                 = string
    size_gb              = number
    storage_account_type = string
    caching              = string
    lun                  = number
  }))
  default = []

  validation {
    condition = alltrue([
      for disk in var.data_disks : disk.size_gb >= 4 && disk.size_gb <= 32767
    ])
    error_message = "Tamanho dos discos de dados deve estar entre 4 e 32767 GB."
  }

  validation {
    condition = alltrue([
      for disk in var.data_disks : contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS"], disk.storage_account_type)
    ])
    error_message = "Tipo de storage dos discos de dados deve ser 'Standard_LRS', 'StandardSSD_LRS' ou 'Premium_LRS'."
  }

  validation {
    condition = alltrue([
      for disk in var.data_disks : contains(["None", "ReadOnly", "ReadWrite"], disk.caching)
    ])
    error_message = "Cache dos discos de dados deve ser 'None', 'ReadOnly' ou 'ReadWrite'."
  }
}

# ==============================================================================
# OPTIONAL VARIABLES - Advanced Configuration
# ==============================================================================

variable "enable_boot_diagnostics" {
  description = "Habilitar boot diagnostics"
  type        = bool
  default     = true
}

variable "boot_diagnostics_storage_account" {
  description = "Storage account para boot diagnostics (deixe null para usar managed storage)"
  type        = string
  default     = null
}

variable "availability_set_id" {
  description = "ID do Availability Set"
  type        = string
  default     = null
}

variable "proximity_placement_group_id" {
  description = "ID do Proximity Placement Group"
  type        = string
  default     = null
}

variable "zone" {
  description = "Availability Zone"
  type        = string
  default     = null

  validation {
    condition     = var.zone == null ? true : contains(["1", "2", "3"], var.zone)
    error_message = "Zone deve ser '1', '2' ou '3'."
  }
}

variable "enable_accelerated_networking" {
  description = "Habilitar accelerated networking"
  type        = bool
  default     = false
}

variable "enable_ip_forwarding" {
  description = "Habilitar IP forwarding"
  type        = bool
  default     = false
}

# ==============================================================================
# OPTIONAL VARIABLES - Identity and Extensions
# ==============================================================================

variable "identity_type" {
  description = "Tipo de identidade gerenciada"
  type        = string
  default     = "SystemAssigned"

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type)
    error_message = "Tipo de identidade deve ser 'SystemAssigned', 'UserAssigned' ou 'SystemAssigned, UserAssigned'."
  }
}

variable "identity_ids" {
  description = "Lista de IDs de identidades gerenciadas pelo usuário"
  type        = list(string)
  default     = []
}

# ==============================================================================
# OPTIONAL VARIABLES - Network Creation
# ==============================================================================

variable "create_vnet" {
  description = "Criar uma nova Virtual Network (se true, subnet_id será ignorado)"
  type        = bool
  default     = false
}

variable "vnet_name" {
  description = "Nome da Virtual Network (usado quando create_vnet = true)"
  type        = string
  default     = null
}

variable "vnet_address_space" {
  description = "Espaço de endereçamento da VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Nome da subnet (usado quando create_vnet = true)"
  type        = string
  default     = null
}

variable "subnet_address_prefixes" {
  description = "Prefixos de endereçamento da subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}


variable "vnet_module_additional_vars" {
  description = "Variáveis adicionais para o módulo de VNet"
  type        = map(any)
  default     = {}
}

# ==============================================================================
# OPTIONAL VARIABLES - Tags and Naming
# ==============================================================================

variable "tags" {
  description = "Tags para aplicar aos recursos"
  type        = map(string)
  default     = {}
}

variable "common_tags" {
  description = "Tags comuns aplicadas automaticamente"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Module    = "tf-az-module-vm"
  }
}
