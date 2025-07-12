# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

Se você descobrir uma vulnerabilidade de segurança, por favor **NÃO** abra uma issue pública. 

### Como Reportar

1. Envie um email para: `security@your-org.com`
2. Inclua:
   - Descrição da vulnerabilidade
   - Passos para reproduzir
   - Impacto potencial
   - Versão afetada
   - Sugestão de correção (se tiver)

### O que Esperar

- **Confirmação**: Resposta em até 48 horas
- **Análise**: Avaliação inicial em até 5 dias úteis
- **Correção**: Timeline baseada na severidade
- **Disclosure**: Coordenado após correção

### Severidade

- **Crítica**: Exposição de credenciais, RCE
- **Alta**: Elevação de privilégios, data exposure
- **Média**: DoS, information disclosure
- **Baixa**: Configurações inadequadas

## Melhores Práticas de Segurança

### Para Usuários do Módulo

1. **Credenciais**
   - Nunca hardcode senhas no código
   - Use Azure Key Vault para secrets
   - Prefira SSH keys para Linux VMs
   - Use identidades gerenciadas quando possível

2. **Rede**
   - Revise regras do NSG antes de aplicar
   - Use IPs públicos apenas quando necessário
   - Implemente network segmentation
   - Configure logging de rede

3. **Storage**
   - Use Premium SSD quando possível
   - Habilite encryption at rest
   - Configure backup adequado
   - Monitore access patterns

4. **Compliance**
   - Revise tags obrigatórias
   - Valide configurações com policies
   - Documente decisões de arquitetura
   - Implemente least privilege

### Exemplo Seguro

```hcl
module "vm" {
  source = "github.com/your-org/tf-az-module-vm?ref=v1.0.0"

  # Configurações básicas
  resource_group_name = "rg-production"
  location           = "East US"
  vm_name            = "vm-app-prod"

  # Rede (usar subnet privada)
  subnet_id        = data.azurerm_subnet.private.id
  create_public_ip = false  # Evitar IP público

  # Segurança
  os_type        = "linux"
  admin_username = "azureuser"
  ssh_public_key = data.azurerm_key_vault_secret.ssh_key.value
  
  # Sem senha para Linux
  admin_password = null
  disable_password_authentication = true

  # Storage seguro
  os_disk_storage_account_type = "Premium_LRS"
  
  # NSG restritivo (exemplo)
  nsg_rules = [
    {
      name                       = "SSH-from-jumpbox"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "10.0.0.10/32"  # IP do jumpbox
      destination_address_prefix = "*"
    }
  ]

  # Identidade gerenciada
  identity_type = "SystemAssigned"

  # Monitoramento
  enable_boot_diagnostics = true

  # Tags para compliance
  tags = {
    Environment = "production"
    DataClass   = "confidential"
    Owner       = "app-team"
    CostCenter  = "12345"
  }
}
```

## Auditoria e Compliance

O módulo inclui:

- Validações automáticas de entrada
- Configurações seguras por padrão
- Suporte para tags de compliance
- Outputs para auditoria
- Integração com Azure Policy

## Contact

Para questões de segurança: `security@your-org.com`
Para outras questões: Abra uma issue no GitHub
