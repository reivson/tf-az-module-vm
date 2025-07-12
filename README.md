# Azure Virtual Machine Terraform Module

[![Terraform Version](https://img.shields.io/badge/terraform-%3E%3D1.0-blue.svg)](https://www.terraform.io/downloads.html)
[![Azure Provider Version](https://img.shields.io/badge/azurerm-%3E%3D3.0-blue.svg)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/release/your-org/tf-az-module-vm)](https://github.com/your-org/tf-az-module-vm/releases)

Este módulo Terraform cria uma Virtual Machine no Azure com todas as dependências necessárias, seguindo as melhores práticas de segurança e performance.

## Recursos Criados

- Virtual Machine (Windows ou Linux)
- Network Interface
- Public IP (opcional)
- Network Security Group com regras básicas
- Managed Disk (opcional para disco adicional)
- Boot Diagnostics Storage Account (opcional)

## Funcionalidades

- ✅ Suporte para Windows e **múltiplas distribuições Linux**
- ✅ **Distribuições Linux suportadas**: Ubuntu, CentOS, RHEL, Oracle Linux, SUSE, Debian, Rocky Linux, AlmaLinux
- ✅ Configuração flexível de tamanho e tipo de VM
- ✅ **Três opções de rede**: subnet existente, VNet via resource, ou VNet via módulo externo
- ✅ Network Security Group com regras customizáveis
- ✅ Suporte para múltiplos discos de dados
- ✅ Configuração de backup (opcional)
- ✅ Boot diagnostics
- ✅ Tags padronizadas
- ✅ Validação extensiva de inputs
- ✅ Outputs estruturados

## Uso Básico

### VM Linux (Ubuntu)
```hcl
module "vm" {
  source = "github.com/your-org/tf-az-module-vm?ref=v1.0.0"

  # Configurações básicas
  resource_group_name = "rg-example"
  location           = "East US"
  vm_name            = "vm-example"
  vm_size            = "Standard_B2s"

  # Configurações de rede
  subnet_id = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/xxx"

  # Configurações do SO
  os_type             = "linux"
  linux_distribution  = "ubuntu"    # ubuntu, centos, rhel, oracle, suse, debian, rocky, alma
  os_version          = "22.04-LTS"

  # Credenciais
  admin_username = "azureuser"
  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2E..." # Recomendado usar Key Vault

  tags = {
    Environment = "development"
    Project     = "example"
  }
}
```

### VM Linux (CentOS)
```hcl
module "vm_centos" {
  source = "github.com/your-org/tf-az-module-vm?ref=v1.0.0"

  # Configurações básicas
  resource_group_name = "rg-example"
  location           = "East US"
  vm_name            = "vm-centos-example"

  # Configurações de rede
  subnet_id = "/subscriptions/xxx/.../subnets/xxx"

  # Configurações do SO
  os_type             = "linux"
  linux_distribution  = "centos"
  os_version          = "8_5"

  # Credenciais
  admin_username = "centos"
  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2E..."

  tags = {
    Environment = "production"
    Distribution = "CentOS"
  }
}
```

## Exemplos

Veja os exemplos completos na pasta [examples/](./examples/).

- [VM Linux básica (Ubuntu)](./examples/linux-basic/)
- [VM Windows com disco adicional](./examples/windows-with-data-disk/)
- [Múltiplas distribuições Linux](./examples/linux-distributions/)
- [VM com configurações avançadas de rede](./examples/with-vnet-module/)

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| resource_group_name | Nome do Resource Group | `string` | n/a | sim |
| location | Localização dos recursos | `string` | n/a | sim |
| vm_name | Nome da Virtual Machine | `string` | n/a | sim |
| vm_size | Tamanho da VM | `string` | `"Standard_B2s"` | não |
| subnet_id | ID da subnet | `string` | n/a | sim |
| os_type | Tipo do SO (linux/windows) | `string` | `"linux"` | não |
| admin_username | Nome do usuário administrador | `string` | n/a | sim |
| admin_password | Senha do administrador | `string` | `null` | não |
| ssh_public_key | Chave SSH pública (apenas Linux) | `string` | `null` | não |

Para lista completa de inputs, veja [INPUTS.md](./INPUTS.md).

## Outputs

| Nome | Descrição |
|------|-----------|
| vm_id | ID da Virtual Machine |
| vm_name | Nome da Virtual Machine |
| private_ip_address | Endereço IP privado |
| public_ip_address | Endereço IP público (se criado) |
| network_interface_id | ID da Network Interface |

Para lista completa de outputs, veja [OUTPUTS.md](./OUTPUTS.md).

## Versionamento

Este módulo segue [Semantic Versioning](https://semver.org/). Para mudanças e versões, veja o [CHANGELOG.md](./CHANGELOG.md).

## Contribuição

Veja [CONTRIBUTING.md](./CONTRIBUTING.md) para detalhes sobre como contribuir.

## Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](./LICENSE) para detalhes.

## Suporte

Para suporte, abra uma issue no [GitHub Issues](https://github.com/your-org/tf-az-module-vm/issues).

## Opções de Rede

O módulo oferece flexibilidade para configuração de rede:

### 1. Criar nova VNet (Recomendado para desenvolvimento)
```hcl
create_vnet = true
# O módulo criará automaticamente VNet, Subnet, NSG e Public IP
```

### 2. Usar subnet existente (Recomendado para produção)
```hcl
create_vnet = false
subnet_id   = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/xxx"
```

## Distribuições Linux Suportadas

| Distribuição | Publisher | Versões Comuns | Observações |
|--------------|-----------|-----------------|-------------|
| **Ubuntu** | Canonical | 18.04-LTS, 20.04-LTS, 22.04-LTS | Gratuito, amplamente usado |
| **CentOS** | OpenLogic | 7_9, 8_5 | Gratuito, baseado em RHEL |
| **RHEL** | RedHat | 8-lvm, 9-lvm | Comercial, suporte oficial Red Hat |
| **Oracle Linux** | Oracle | ol85, ol86, ol87 | Gratuito, compatível com RHEL |
| **SUSE** | SUSE | gen2, gen1 | Comercial, enterprise Linux |
| **Debian** | Debian | 10, 11 | Gratuito, estável |
| **Rocky Linux** | Rocky Foundation | rockylinux-8, rockylinux-9 | Gratuito, sucessor do CentOS |
| **AlmaLinux** | AlmaLinux | 8-gen2, 9-gen2 | Gratuito, compatível com RHEL |

### Exemplo de Uso por Distribuição

```hcl
# Ubuntu
linux_distribution = "ubuntu"
os_version         = "22.04-LTS"

# CentOS
linux_distribution = "centos"
os_version         = "8_5"

# Red Hat Enterprise Linux
linux_distribution = "rhel"
os_version         = "8-lvm"

# Oracle Linux
linux_distribution = "oracle"
os_version         = "ol85"

# SUSE Linux Enterprise Server
linux_distribution = "suse"
os_version         = "gen2"

# Rocky Linux
linux_distribution = "rocky"
os_version         = "rockylinux-8"
```

### Considerações de Custos

- **Gratuitas**: Ubuntu, CentOS, Oracle Linux, Debian, Rocky Linux, AlmaLinux
- **Comerciais**: RHEL (requer licença), SUSE (requer licença)
- **Verificar disponibilidade**: Nem todas as versões estão disponíveis em todas as regiões Azure
