# Exemplo: Diferentes Distribuições Linux

Este exemplo demonstra como criar VMs com diferentes distribuições Linux suportadas pelo módulo.

## Distribuições Suportadas

### Ubuntu
- **Publisher**: Canonical
- **Offer**: 0001-com-ubuntu-server-focal
- **Versões**: 18.04-LTS, 20.04-LTS, 22.04-LTS

### CentOS
- **Publisher**: OpenLogic
- **Offer**: CentOS
- **Versões**: 7_9, 8_5

### Red Hat Enterprise Linux (RHEL)
- **Publisher**: RedHat
- **Offer**: RHEL
- **Versões**: 8-lvm, 9-lvm

### Oracle Linux
- **Publisher**: Oracle
- **Offer**: Oracle-Linux
- **Versões**: ol85, ol86, ol87

### SUSE Linux Enterprise Server (SLES)
- **Publisher**: SUSE
- **Offer**: sles-15-sp3
- **Versões**: gen2, gen1

### Debian
- **Publisher**: Debian
- **Offer**: debian-11
- **Versões**: 11, 10

### Rocky Linux
- **Publisher**: erockyenterprisesoftwarefoundationinc1653071250513
- **Offer**: rockylinux
- **Versões**: rockylinux-8, rockylinux-9

### AlmaLinux
- **Publisher**: almalinux
- **Offer**: almalinux
- **Versões**: 8-gen2, 9-gen2

## Uso

### Exemplo 1: Ubuntu 22.04 LTS
```hcl
module "ubuntu_vm" {
  source = "../../"
  
  vm_name             = "vm-ubuntu"
  linux_distribution  = "ubuntu"
  os_version          = "22.04-LTS"
  # ... outras configurações
}
```

### Exemplo 2: CentOS 8
```hcl
module "centos_vm" {
  source = "../../"
  
  vm_name             = "vm-centos"
  linux_distribution  = "centos"
  os_version          = "8_5"
  # ... outras configurações
}
```

### Exemplo 3: Oracle Linux 8.5
```hcl
module "oracle_vm" {
  source = "../../"
  
  vm_name             = "vm-oracle"
  linux_distribution  = "oracle"
  os_version          = "ol85"
  # ... outras configurações
}
```

## Como usar

1. Configure as variáveis no arquivo `terraform.tfvars`
2. Execute os comandos:

```bash
terraform init
terraform plan
terraform apply
```

## Observações

- Algumas distribuições podem ter custos adicionais (RHEL, SLES)
- Verifique a disponibilidade da imagem na região escolhida
- Considere os requisitos de licenciamento de cada distribuição
