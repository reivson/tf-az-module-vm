output "vm_summaries" {
  description = "Resumo de todas as VMs criadas"
  value = {
    ubuntu = var.create_ubuntu ? module.ubuntu_vm[0].vm_summary : null
    centos = var.create_centos ? module.centos_vm[0].vm_summary : null
    rhel   = var.create_rhel ? module.rhel_vm[0].vm_summary : null
    oracle = var.create_oracle ? module.oracle_vm[0].vm_summary : null
    suse   = var.create_suse ? module.suse_vm[0].vm_summary : null
    rocky  = var.create_rocky ? module.rocky_vm[0].vm_summary : null
  }
}

output "ssh_connections" {
  description = "Comandos SSH para conectar às VMs"
  value = {
    ubuntu = var.create_ubuntu ? module.ubuntu_vm[0].ssh_connection_command : null
    centos = var.create_centos ? module.centos_vm[0].ssh_connection_command : null
    rhel   = var.create_rhel ? module.rhel_vm[0].ssh_connection_command : null
    oracle = var.create_oracle ? module.oracle_vm[0].ssh_connection_command : null
    suse   = var.create_suse ? module.suse_vm[0].ssh_connection_command : null
    rocky  = var.create_rocky ? module.rocky_vm[0].ssh_connection_command : null
  }
}

output "private_ips" {
  description = "IPs privados das VMs"
  value = {
    ubuntu = var.create_ubuntu ? module.ubuntu_vm[0].private_ip_address : null
    centos = var.create_centos ? module.centos_vm[0].private_ip_address : null
    rhel   = var.create_rhel ? module.rhel_vm[0].private_ip_address : null
    oracle = var.create_oracle ? module.oracle_vm[0].private_ip_address : null
    suse   = var.create_suse ? module.suse_vm[0].private_ip_address : null
    rocky  = var.create_rocky ? module.rocky_vm[0].private_ip_address : null
  }
}

output "public_ips" {
  description = "IPs públicos das VMs (se criados)"
  value = {
    ubuntu = var.create_ubuntu ? module.ubuntu_vm[0].public_ip_address : null
    centos = var.create_centos ? module.centos_vm[0].public_ip_address : null
    rhel   = var.create_rhel ? module.rhel_vm[0].public_ip_address : null
    oracle = var.create_oracle ? module.oracle_vm[0].public_ip_address : null
    suse   = var.create_suse ? module.suse_vm[0].public_ip_address : null
    rocky  = var.create_rocky ? module.rocky_vm[0].public_ip_address : null
  }
}

output "vm_ids" {
  description = "IDs das VMs criadas"
  value = {
    ubuntu = var.create_ubuntu ? module.ubuntu_vm[0].vm_id : null
    centos = var.create_centos ? module.centos_vm[0].vm_id : null
    rhel   = var.create_rhel ? module.rhel_vm[0].vm_id : null
    oracle = var.create_oracle ? module.oracle_vm[0].vm_id : null
    suse   = var.create_suse ? module.suse_vm[0].vm_id : null
    rocky  = var.create_rocky ? module.rocky_vm[0].vm_id : null
  }
}

output "distributions_created" {
  description = "Lista das distribuições que foram criadas"
  value = [
    for dist, created in {
      ubuntu = var.create_ubuntu
      centos = var.create_centos
      rhel   = var.create_rhel
      oracle = var.create_oracle
      suse   = var.create_suse
      rocky  = var.create_rocky
    } : dist if created
  ]
}
