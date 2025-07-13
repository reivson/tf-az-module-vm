# 🔒 Security Policy

## 🛡️ Versões Suportadas

Mantemos suporte de segurança para as seguintes versões:

| Versão | Suportada          |
| ------ | ------------------ |
| 1.x.x  | ✅ Sim             |
| 0.x.x  | ❌ Não (deprecated) |

## 🚨 Reportando Vulnerabilidades de Segurança

A segurança do nosso módulo é levada muito a sério. Se você descobrir uma vulnerabilidade de segurança, por favor **NÃO** abra uma issue pública.

### 📧 Processo de Reporte

1. **Envie um email para**: [reivson@example.com](mailto:reivson@example.com)
2. **Inclua as seguintes informações**:
   - Descrição detalhada da vulnerabilidade
   - Passos para reproduzir o problema
   - Impacto potencial
   - Versão afetada do módulo
   - Qualquer informação adicional relevante

### ⏱️ Tempo de Resposta

- **Confirmação inicial**: 48 horas
- **Avaliação detalhada**: 7 dias
- **Correção e release**: 30 dias (dependendo da complexidade)

### 🔐 Processo de Correção

1. **Verificação** - Confirmamos e reproduzimos a vulnerabilidade
2. **Desenvolvimento** - Criamos uma correção em repositório privado
3. **Teste** - Testamos a correção extensivamente
4. **Release** - Publicamos patch de segurança
5. **Divulgação** - Comunicamos após correção estar disponível

## 🛡️ Práticas de Segurança

### Para Usuários do Módulo

1. **Mantenha versões atualizadas**
   ```hcl
   module "vm" {
     source = "github.com/reivson/tf-az-module-vm?ref=v1.2.3" # Use versão específica
     # ...
   }
   ```

2. **Use Terraform state remoto seguro**
   ```hcl
   terraform {
     backend "azurerm" {
       # Configure com criptografia
     }
   }
   ```

3. **Implemente network security groups adequados**
   ```hcl
   module "vm" {
     source = "github.com/reivson/tf-az-module-vm"
     
     security_rules = [
       {
         name     = "SSH"
         priority = 1001
         access   = "Allow"
         protocol = "Tcp"
         direction = "Inbound"
         source_port_range = "*"
         destination_port_range = "22"
         source_address_prefix = "YOUR_SPECIFIC_IP"  # Não use "*"
         destination_address_prefix = "*"
       }
     ]
   }
   ```

4. **Use Azure Key Vault para senhas**
   ```hcl
   module "vm" {
     source = "github.com/reivson/tf-az-module-vm"
     
     admin_password_key_vault_secret_id = data.azurerm_key_vault_secret.vm_password.id
   }
   ```

### Para Contribuidores

1. **Nunca commite secrets**
   - Use `.gitignore` adequadamente
   - Escaneie commits com ferramentas como git-secrets

2. **Valide inputs de usuário**
   ```hcl
   variable "admin_username" {
     type        = string
     description = "Nome do usuário administrador"
     
     validation {
       condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_-]{2,19}$", var.admin_username))
       error_message = "Username deve ter 3-20 caracteres, começar com letra."
     }
   }
   ```

3. **Use least privilege principle**
   - Configure permissões mínimas necessárias
   - Documente requirements de permissão

## 🔍 Auditoria de Segurança

### Verificações Automáticas

Nosso pipeline CI/CD inclui:

- **Terraform security scanning** com Checkov
- **Dependency scanning** para providers
- **SAST (Static Application Security Testing)**
- **Infrastructure as Code security scanning**

### Verificações Manuais

Realizamos reviews manuais para:

- Mudanças em configurações de rede
- Novas funcionalidades de segurança
- Updates de dependências críticas

## 📋 Security Checklist

Antes de usar este módulo em produção:

- [ ] ✅ Configurei network security groups adequados
- [ ] ✅ Habilitei monitoramento e logging
- [ ] ✅ Configurei backup e disaster recovery
- [ ] ✅ Implementei principle of least privilege
- [ ] ✅ Configurei update management
- [ ] ✅ Habilitei Azure Security Center
- [ ] ✅ Configurei Key Vault para secrets
- [ ] ✅ Implementei network segmentation
- [ ] ✅ Configurei just-in-time access (se aplicável)
- [ ] ✅ Testei procedures de incident response

## 🎯 Recursos de Segurança

### Azure Security Features

Este módulo suporta as seguintes features de segurança do Azure:

- **Azure Security Center** integration
- **Azure Monitor** logging
- **Network Security Groups** customizáveis
- **Azure Key Vault** integration
- **Managed Identity** support
- **Disk encryption** options
- **Backup** configuration

### Compliance

O módulo foi projetado considerando:

- **CIS Azure Foundations Benchmark**
- **Azure Security Benchmark**
- **NIST Cybersecurity Framework**
- **ISO 27001** requirements

## 📞 Contato de Segurança

- **Email**: reivson@example.com
- **PGP Key**: [Link para chave pública]
- **Security Advisories**: GitHub Security Advisories

## 📋 Histórico de Security Advisories

Todas as vulnerabilidades corrigidas são documentadas em:
- [GitHub Security Advisories](https://github.com/reivson/tf-az-module-vm/security/advisories)
- Release notes com tag `security`

---

**Obrigado por ajudar a manter nosso módulo seguro! 🔒**
