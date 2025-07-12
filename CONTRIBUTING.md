# Contributing to Terraform Azure VM Module

Obrigado pelo seu interesse em contribuir! Este documento fornece diretrizes para contribuir com o módulo.

## Código de Conduta

Este projeto adere ao [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). Ao participar, você deve seguir este código.

## Como Contribuir

### Reportando Bugs

1. Verifique se o bug já foi reportado nas [Issues](https://github.com/your-org/tf-az-module-vm/issues)
2. Se não encontrou, crie uma nova issue com:
   - Título descritivo
   - Descrição detalhada do problema
   - Passos para reproduzir
   - Versão do Terraform e provider AzureRM
   - Exemplos de código (se aplicável)

### Sugerindo Melhorias

1. Abra uma issue com o label `enhancement`
2. Descreva a melhoria proposta
3. Explique o caso de uso
4. Forneça exemplos se possível

### Enviando Pull Requests

#### Preparação

1. Fork o repositório
2. Crie uma branch a partir de `develop`: `git checkout -b feature/my-feature develop`
3. Faça suas alterações
4. Teste suas alterações

#### Requisitos para PR

- [ ] Código segue o [Terraform Style Guide](https://www.terraform.io/docs/language/syntax/style.html)
- [ ] Todas as validações passam (`terraform validate`)
- [ ] Código está formatado (`terraform fmt`)
- [ ] Testes passam (se aplicável)
- [ ] Documentação foi atualizada
- [ ] CHANGELOG.md foi atualizado

#### Processo de Review

1. Abra o PR contra a branch `develop`
2. Preencha o template de PR
3. Aguarde review dos maintainers
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

### Padrões de Código

#### Terraform

- Use `snake_case` para nomes de recursos e variáveis
- Agrupe recursos relacionados com comentários
- Use validações para inputs quando apropriado
- Documente todas as variáveis e outputs
- Use locals para valores computados
- Prefira dynamic blocks para configurações opcionais

#### Exemplo de Variável

```hcl
variable "vm_size" {
  description = "Tamanho da Virtual Machine"
  type        = string
  default     = "Standard_B2s"

  validation {
    condition = contains([
      "Standard_B1s", "Standard_B2s", "Standard_D2s_v3"
    ], var.vm_size)
    error_message = "Tamanho de VM inválido."
  }
}
```

#### Exemplo de Output

```hcl
output "vm_id" {
  description = "ID da Virtual Machine criada"
  value       = azurerm_linux_virtual_machine.main.id
}
```

### Versionamento

Este projeto segue [Semantic Versioning](https://semver.org/):

- **MAJOR**: Mudanças incompatíveis
- **MINOR**: Nova funcionalidade compatível
- **PATCH**: Correções compatíveis

### Documentação

- Mantenha o README.md atualizado
- Documente novos recursos nos exemplos
- Atualize o CHANGELOG.md
- Use comentários no código quando necessário

### Releases

Releases são criados automaticamente via GitHub Actions quando mudanças são mergeadas na branch `main`.

## Suporte

- GitHub Issues: Para bugs e feature requests
- GitHub Discussions: Para perguntas gerais
- Wiki: Para documentação adicional

## Licença

Ao contribuir, você concorda que suas contribuições serão licenciadas sob a [MIT License](LICENSE).
