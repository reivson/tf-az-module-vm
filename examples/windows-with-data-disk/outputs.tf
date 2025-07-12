output "vm_summary" {
  description = "Resumo da VM criada"
  value       = module.windows_vm.vm_summary
}

output "rdp_connection" {
  description = "Comando para conectar via RDP"
  value       = module.windows_vm.rdp_connection_command
}

output "admin_username" {
  description = "Nome do usuário administrador"
  value       = module.windows_vm.vm_admin_username
}

output "private_ip" {
  description = "IP privado da VM"
  value       = module.windows_vm.private_ip_address
}

output "public_ip" {
  description = "IP público da VM"
  value       = module.windows_vm.public_ip_address
}

output "vm_id" {
  description = "ID da VM"
  value       = module.windows_vm.vm_id
}

output "data_disks" {
  description = "Informações dos discos de dados"
  value = {
    ids   = module.windows_vm.data_disk_ids
    names = module.windows_vm.data_disk_names
    sizes = module.windows_vm.data_disk_sizes
  }
}

output "identity_principal_id" {
  description = "Principal ID da identidade gerenciada"
  value       = module.windows_vm.identity_principal_id
}
