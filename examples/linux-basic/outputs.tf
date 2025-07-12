output "vm_summary" {
  description = "Resumo da VM criada"
  value       = module.linux_vm.vm_summary
}

output "ssh_connection" {
  description = "Comando para conectar via SSH"
  value       = module.linux_vm.ssh_connection_command
}

output "private_ip" {
  description = "IP privado da VM"
  value       = module.linux_vm.private_ip_address
}

output "public_ip" {
  description = "IP público da VM"
  value       = module.linux_vm.public_ip_address
}

output "vm_id" {
  description = "ID da VM"
  value       = module.linux_vm.vm_id
}
