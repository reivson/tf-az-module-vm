# ==============================================================================
# VIRTUAL MACHINE OUTPUTS
# ==============================================================================

output "vm_id" {
  description = "ID da Virtual Machine"
  value       = var.os_type == "linux" ? (length(azurerm_linux_virtual_machine.main) > 0 ? azurerm_linux_virtual_machine.main["default"].id : null) : (length(azurerm_windows_virtual_machine.main) > 0 ? azurerm_windows_virtual_machine.main["default"].id : null)
}

output "vm_name" {
  description = "Nome da Virtual Machine"
  value       = var.os_type == "linux" ? (length(azurerm_linux_virtual_machine.main) > 0 ? azurerm_linux_virtual_machine.main["default"].name : null) : (length(azurerm_windows_virtual_machine.main) > 0 ? azurerm_windows_virtual_machine.main["default"].name : null)
}

output "vm_size" {
  description = "Tamanho da Virtual Machine"
  value       = var.vm_size
}

output "vm_location" {
  description = "Localização da Virtual Machine"
  value       = var.location
}

output "vm_resource_group_name" {
  description = "Nome do Resource Group da Virtual Machine"
  value       = var.resource_group_name
}

output "vm_zone" {
  description = "Availability Zone da Virtual Machine"
  value       = var.zone
}

output "vm_os_type" {
  description = "Tipo do sistema operacional"
  value       = var.os_type
}

output "vm_linux_distribution" {
  description = "Distribuição Linux (apenas para VMs Linux)"
  value       = var.os_type == "linux" ? var.linux_distribution : null
}

output "vm_os_version" {
  description = "Versão do sistema operacional"
  value       = var.os_version
}

output "vm_admin_username" {
  description = "Nome do usuário administrador"
  value       = var.admin_username
}

# ==============================================================================
# NETWORK OUTPUTS
# ==============================================================================

output "network_interface_id" {
  description = "ID da Network Interface"
  value       = azurerm_network_interface.main.id
}

output "network_interface_name" {
  description = "Nome da Network Interface"
  value       = azurerm_network_interface.main.name
}

output "private_ip_address" {
  description = "Endereço IP privado da VM"
  value       = azurerm_network_interface.main.private_ip_address
}

output "private_ip_addresses" {
  description = "Lista de endereços IP privados da VM"
  value       = azurerm_network_interface.main.private_ip_addresses
}

output "public_ip_id" {
  description = "ID do IP público (se criado)"
  value       = var.create_public_ip ? (length(azurerm_public_ip.main) > 0 ? azurerm_public_ip.main["default"].id : null) : null
}

output "public_ip_address" {
  description = "Endereço IP público da VM (se criado)"
  value       = var.create_public_ip ? (length(azurerm_public_ip.main) > 0 ? azurerm_public_ip.main["default"].ip_address : null) : null
}

output "public_ip_fqdn" {
  description = "FQDN do IP público (se configurado)"
  value       = var.create_public_ip ? (length(azurerm_public_ip.main) > 0 ? azurerm_public_ip.main["default"].fqdn : null) : null
}

output "network_security_group_id" {
  description = "ID do Network Security Group"
  value       = azurerm_network_security_group.main.id
}

output "network_security_group_name" {
  description = "Nome do Network Security Group"
  value       = azurerm_network_security_group.main.name
}

output "subnet_id" {
  description = "ID da subnet utilizada"
  value       = local.subnet_id
}

output "vnet_id" {
  description = "ID da Virtual Network (se criada pelo módulo)"
  value       = var.create_vnet ? (length(azurerm_virtual_network.main) > 0 ? azurerm_virtual_network.main["default"].id : null) : null
}

output "vnet_name" {
  description = "Nome da Virtual Network (se criada pelo módulo)"
  value       = var.create_vnet ? (length(azurerm_virtual_network.main) > 0 ? azurerm_virtual_network.main["default"].name : null) : null
}

output "network_creation_method" {
  description = "Método usado para criar a rede"
  value = var.create_vnet ? (
    var.create_vnet ? "direct_resources" : "existing_subnet"
  ) : "existing_subnet"
}

# ==============================================================================
# STORAGE OUTPUTS
# ==============================================================================

output "os_disk_id" {
  description = "ID do disco do sistema operacional"
  value       = var.os_type == "linux" ? (length(azurerm_linux_virtual_machine.main) > 0 ? azurerm_linux_virtual_machine.main["default"].os_disk[0].name : null) : (length(azurerm_windows_virtual_machine.main) > 0 ? azurerm_windows_virtual_machine.main["default"].os_disk[0].name : null)
}

output "os_disk_size_gb" {
  description = "Tamanho do disco do SO em GB"
  value       = var.os_disk_size_gb
}

output "os_disk_storage_account_type" {
  description = "Tipo de storage account do disco do SO"
  value       = var.os_disk_storage_account_type
}

output "data_disk_ids" {
  description = "IDs dos discos de dados"
  value       = values(azurerm_managed_disk.data)[*].id
}

output "data_disk_names" {
  description = "Nomes dos discos de dados"
  value       = values(azurerm_managed_disk.data)[*].name
}

output "data_disk_sizes" {
  description = "Tamanhos dos discos de dados em GB"
  value       = var.data_disks[*].size_gb
}

# ==============================================================================
# IDENTITY OUTPUTS
# ==============================================================================

output "identity_principal_id" {
  description = "Principal ID da identidade gerenciada (se habilitada)"
  value = var.identity_type == "SystemAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? (
    var.os_type == "linux" ?
    (length(azurerm_linux_virtual_machine.main) > 0 ? azurerm_linux_virtual_machine.main["default"].identity[0].principal_id : null) :
    (length(azurerm_windows_virtual_machine.main) > 0 ? azurerm_windows_virtual_machine.main["default"].identity[0].principal_id : null)
  ) : null
}

output "identity_tenant_id" {
  description = "Tenant ID da identidade gerenciada (se habilitada)"
  value = var.identity_type == "SystemAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? (
    var.os_type == "linux" ?
    (length(azurerm_linux_virtual_machine.main) > 0 ? azurerm_linux_virtual_machine.main["default"].identity[0].tenant_id : null) :
    (length(azurerm_windows_virtual_machine.main) > 0 ? azurerm_windows_virtual_machine.main["default"].identity[0].tenant_id : null)
  ) : null
}

output "identity_type" {
  description = "Tipo de identidade gerenciada configurada"
  value       = var.identity_type
}

# ==============================================================================
# CONNECTION OUTPUTS
# ==============================================================================

output "ssh_connection_command" {
  description = "Comando SSH para conectar à VM Linux (se aplicável)"
  value       = var.os_type == "linux" && var.create_public_ip ? (length(azurerm_public_ip.main) > 0 ? "ssh ${var.admin_username}@${azurerm_public_ip.main["default"].ip_address}" : null) : null
}

output "rdp_connection_command" {
  description = "Comando RDP para conectar à VM Windows (se aplicável)"
  value       = var.os_type == "windows" && var.create_public_ip ? (length(azurerm_public_ip.main) > 0 ? "mstsc /v:${azurerm_public_ip.main["default"].ip_address}" : null) : null
}

# ==============================================================================
# SUMMARY OUTPUT
# ==============================================================================

output "vm_summary" {
  description = "Resumo completo da Virtual Machine criada"
  value = {
    vm_id                   = var.os_type == "linux" ? (length(azurerm_linux_virtual_machine.main) > 0 ? azurerm_linux_virtual_machine.main["default"].id : null) : (length(azurerm_windows_virtual_machine.main) > 0 ? azurerm_windows_virtual_machine.main["default"].id : null)
    vm_name                 = var.vm_name
    vm_size                 = var.vm_size
    os_type                 = var.os_type
    linux_distribution      = var.os_type == "linux" ? var.linux_distribution : null
    os_version              = var.os_version
    location                = var.location
    resource_group_name     = var.resource_group_name
    zone                    = var.zone
    private_ip_address      = azurerm_network_interface.main.private_ip_address
    public_ip_address       = var.create_public_ip ? (length(azurerm_public_ip.main) > 0 ? azurerm_public_ip.main["default"].ip_address : null) : null
    network_interface_id    = azurerm_network_interface.main.id
    network_security_group  = azurerm_network_security_group.main.name
    data_disks_count        = length(var.data_disks)
    identity_enabled        = var.identity_type != null
    boot_diagnostics        = var.enable_boot_diagnostics
    accelerated_networking  = var.enable_accelerated_networking
    network_creation_method = var.create_vnet ? "direct_resources" : "existing_subnet"
  }
}
