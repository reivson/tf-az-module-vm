# Testes do Módulo

Este diretório contém testes para validar o módulo Terraform.

## Tipos de Teste

### 1. Testes de Validação
- Validação de sintaxe Terraform
- Validação de variáveis e tipos
- Testes de formatação

### 2. Testes de Integração
- Testes com Terratest
- Validação de recursos criados
- Testes de conectividade

## Executar Testes

### Validação Básica
```bash
# Validar sintaxe
terraform fmt -check -recursive
terraform validate

# Verificar segurança
tfsec .
```

### Testes Automatizados
```bash
# Instalar dependências
go mod init
go mod tidy

# Executar testes
go test -v -timeout 30m
```

## Estrutura de Testes

```
tests/
├── README.md                 # Este arquivo
├── terraform_basic_test.go   # Testes básicos
├── terraform_advanced_test.go # Testes avançados
├── go.mod                    # Dependências Go
└── fixtures/                 # Configurações de teste
    ├── basic/
    └── advanced/
```
