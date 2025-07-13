# 🤝 Contributing para tf-az-module-vm

Obrigado por considerar contribuir para o nosso módulo Terraform! 🎉

## 📋 Índice

- [🚀 Como Começar](#-como-começar)
- [🛠️ Processo de Desenvolvimento](#️-processo-de-desenvolvimento)
- [📝 Diretrizes de Código](#-diretrizes-de-código)
- [🧪 Testes](#-testes)
- [📚 Documentação](#-documentação)
- [🔄 Pull Requests](#-pull-requests)
- [🐛 Reportar Bugs](#-reportar-bugs)
- [💡 Sugerir Melhorias](#-sugerir-melhorias)

## 🚀 Como Começar

### Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) >= 1.2
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Conta Azure com permissões adequadas
- [Git](https://git-scm.com/)

### Setup do Ambiente

1. **Fork o repositório**
   ```bash
   # Clone seu fork
   git clone https://github.com/SEU_USERNAME/tf-az-module-vm.git
   cd tf-az-module-vm
   
   # Adicione o repositório original como upstream
   git remote add upstream https://github.com/reivson/tf-az-module-vm.git
   ```

2. **Configure o Azure**
   ```bash
   # Login no Azure
   az login
   
   # Configure a subscription (se necessário)
   az account set --subscription "sua-subscription-id"
   ```

3. **Teste a configuração**
   ```bash
   # Valide o módulo
   terraform init
   terraform validate
   
   # Teste um exemplo
   cd examples/simple-linux-vm
   terraform init
   terraform plan
   ```

## 🛠️ Processo de Desenvolvimento

### Workflow de Contribuição

1. **Crie uma branch para sua feature/bugfix**
   ```bash
   git checkout -b feature/nova-funcionalidade
   # ou
   git checkout -b bugfix/correcao-importante
   ```

2. **Faça suas mudanças seguindo as diretrizes**

3. **Teste suas mudanças**
   ```bash
   # Valide o código
   terraform fmt -recursive
   terraform validate
   
   # Execute testes (se aplicável)
   cd tests/
   terraform test
   ```

4. **Commit suas mudanças**
   ```bash
   git add .
   git commit -m "feat: adiciona suporte para distribuição Oracle Linux"
   ```

5. **Push e crie um Pull Request**
   ```bash
   git push origin feature/nova-funcionalidade
   ```

### Convenções de Branch

- `main` - Branch principal protegida
- `develop` - Branch de desenvolvimento (se aplicável)
- `feature/nome-da-feature` - Novas funcionalidades
- `bugfix/nome-do-bug` - Correções de bugs
- `hotfix/nome-do-hotfix` - Correções urgentes
- `docs/nome-da-doc` - Atualizações de documentação

### Convenções de Commit

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

[optional body]

[optional footer]
```

**Tipos:**
- `feat` - Nova funcionalidade
- `fix` - Correção de bug
- `docs` - Mudanças na documentação
- `style` - Formatação, sem mudança de funcionalidade
- `refactor` - Refatoração sem mudança de funcionalidade
- `test` - Adição ou correção de testes
- `chore` - Tarefas de manutenção

**Exemplos:**
```bash
feat: adiciona suporte para VM com múltiplos discos
fix: corrige validação de tamanho de VM
docs: atualiza exemplo de uso básico
```
4. Faça as alterações solicitadas
5. Após aprovação, o PR será mergeado

## Desenvolvimento

### Pré-requisitos

- Terraform >= 1.0
- Go >= 1.19 (para testes)
- Azure CLI (para testes)
- tfsec (para análise de segurança)

### Setup do Ambiente

```bash
# Clone o fork
git clone https://github.com/your-username/tf-az-module-vm.git
cd tf-az-module-vm

# Configure upstream
git remote add upstream https://github.com/your-org/tf-az-module-vm.git

# Instale dependências de teste
cd tests
go mod download
```

### Executando Testes

```bash
# Validação básica
terraform fmt -check -recursive
terraform validate

# Testes de segurança
tfsec .

# Testes de integração (requer credenciais Azure)
cd tests
go test -v -timeout 30m
```

### Estrutura do Projeto

```
.
├── main.tf              # Recursos principais
├── variables.tf         # Variáveis de entrada
├── outputs.tf           # Outputs do módulo
├── versions.tf          # Versões e providers
├── examples/            # Exemplos de uso
│   ├── linux-basic/
│   ├── windows-with-data-disk/
│   └── with-vnet-module/
├── tests/               # Testes automatizados
├── .github/             # Workflows CI/CD
└── docs/                # Documentação adicional
```

## 📝 Diretrizes de Código

### Estrutura de Arquivos

```
tf-az-module-vm/
├── main.tf              # Recursos principais
├── variables.tf         # Definição de variáveis
├── outputs.tf          # Outputs do módulo
├── versions.tf         # Versões de providers
├── locals.tf           # Valores locais (se necessário)
├── examples/           # Exemplos de uso
├── tests/             # Testes automatizados
└── docs/              # Documentação adicional
```

### Padrões de Código

1. **Formatação**
   ```bash
   # Sempre formate o código
   terraform fmt -recursive
   ```

2. **Nomenclatura**
   - Variáveis: `snake_case`
   - Recursos: `snake_case`
   - Outputs: `snake_case`
   - Locals: `snake_case`

3. **Comentários**
   ```hcl
   # Use comentários para explicar lógica complexa
   variable "vm_config" {
     description = "Configuração da VM - deve ser clara e detalhada"
     type = object({
       size = string  # Tamanho da VM (ex: Standard_B2s)
       os   = string  # SO da VM (linux ou windows)
     })
   }
   ```

4. **Validações**
   ```hcl
   variable "vm_size" {
     type        = string
     description = "Tamanho da VM"
     
     validation {
       condition = contains([
         "Standard_B1s", "Standard_B2s", "Standard_D2s_v3"
       ], var.vm_size)
       error_message = "Tamanho de VM não suportado."
     }
   }
   ```

### Melhores Práticas

1. **Use `for_each` em vez de `count`**
   ```hcl
   # ✅ Recomendado
   resource "azurerm_virtual_machine" "this" {
     for_each = var.vms
     name     = each.key
     # ...
   }
   
   # ❌ Evite
   resource "azurerm_virtual_machine" "this" {
     count = length(var.vm_names)
     name  = var.vm_names[count.index]
     # ...
   }
   ```

2. **Valide inputs importantes**
   ```hcl
   variable "environment" {
     type = string
     validation {
       condition     = contains(["dev", "test", "prod"], var.environment)
       error_message = "Environment deve ser dev, test ou prod."
     }
   }
   ```

3. **Use data sources quando apropriado**
   ```hcl
   data "azurerm_client_config" "current" {}
   ```

## 🧪 Testes

### Tipos de Teste

1. **Validação de Sintaxe**
   ```bash
   terraform fmt -check=true -recursive
   terraform validate
   ```

2. **Testes de Plano**
   ```bash
   cd examples/simple-linux-vm
   terraform init
   terraform plan
   ```

3. **Testes de Aplicação (em ambiente de teste)**
   ```bash
   terraform apply -auto-approve
   terraform destroy -auto-approve
   ```

### Executando Testes Localmente

```bash
# Valide todos os arquivos
terraform fmt -check=true -recursive
terraform validate

# Teste todos os exemplos
for example in examples/*/; do
  echo "Testing $example"
  cd "$example"
  terraform init
  terraform validate
  terraform plan
  cd ../..
done
```

## 📚 Documentação

### Documentação Obrigatória

1. **README.md** - Documentação principal
2. **Variáveis** - Todas as variáveis devem ter descrições claras
3. **Outputs** - Todos os outputs devem ser documentados
4. **Exemplos** - Cada funcionalidade deve ter exemplo

### Atualizando Documentação

1. **Variáveis e Outputs**
   ```hcl
   variable "resource_group_name" {
     description = "Nome do Resource Group onde os recursos serão criados"
     type        = string
   }
   
   output "vm_private_ip" {
     description = "IP privado da VM criada"
     value       = azurerm_linux_virtual_machine.this[*].private_ip_address
   }
   ```

2. **Exemplos**
   - Sempre inclua um exemplo completo
   - Teste o exemplo antes de submeter
   - Documente configurações especiais

## 🔄 Pull Requests

### Checklist para PRs

- [ ] ✅ Código formatado (`terraform fmt`)
- [ ] ✅ Validação passou (`terraform validate`)
- [ ] ✅ Testes locais passaram
- [ ] ✅ Documentação atualizada
- [ ] ✅ Exemplos funcionam
- [ ] ✅ Commit messages seguem convenção
- [ ] ✅ PR template preenchido

### Processo de Review

1. **Verificação Automática** - CI/CD executa testes
2. **Code Review** - Maintainer revisa o código
3. **Testes Manuais** - Se necessário
4. **Merge** - Após aprovação

### Critérios de Aprovação

- ✅ Funcionalidade implementada corretamente
- ✅ Código segue padrões do projeto
- ✅ Testes passam
- ✅ Documentação adequada
- ✅ Compatibilidade mantida (ou breaking change justificado)

## 🐛 Reportar Bugs

Use o template de **Bug Report** com:

1. **Descrição clara** do problema
2. **Passos para reproduzir**
3. **Comportamento esperado vs atual**
4. **Configuração Terraform**
5. **Versões** (Terraform, Provider, Módulo)
6. **Logs/Output** relevantes

## 💡 Sugerir Melhorias

Use o template de **Feature Request** com:

1. **Problema/necessidade** que a feature resolve
2. **Solução proposta** 
3. **Alternativas consideradas**
4. **Exemplo de uso**
5. **Impacto** esperado

## 🎖️ Reconhecimento

Contribuidores são reconhecidos:

- 📝 **Contributors list** no README
- 🏷️ **Release notes** mencionando contribuições
- 🌟 **GitHub stars** para boas contribuições

## 📞 Ajuda

Precisa de ajuda? Você pode:

- 💬 Abrir uma **Discussion**
- ❓ Criar uma **Issue** do tipo "Question"
- 📧 Entrar em contato com maintainers

---

**Obrigado por contribuir! 🚀**

Toda contribuição, independente do tamanho, é valorizada e ajuda a melhorar este módulo para toda a comunidade.
