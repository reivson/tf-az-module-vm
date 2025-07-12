# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Suporte para criação de VNet via módulo externo
- Suporte para criação de VNet via resources diretos
- Validações extensivas de entrada
- Testes automatizados com Terratest
- Pipeline CI/CD completo
- Análise de segurança automatizada
- Documentação automática
- Exemplos de uso detalhados

### Features
- ✅ Suporte para Linux e Windows
- ✅ Configuração flexível de tamanho e tipo de VM
- ✅ Network Security Group com regras customizáveis
- ✅ Suporte para múltiplos discos de dados
- ✅ Boot diagnostics
- ✅ Identidade gerenciada
- ✅ Tags padronizadas
- ✅ Outputs estruturados
- ✅ Três opções de rede: existente, resource direto, ou módulo externo

## [1.0.0] - 2025-07-12

### Added
- Módulo inicial para criação de Virtual Machines no Azure
- Suporte para Linux (Ubuntu) e Windows Server
- Network Security Group com regras básicas
- Suporte para IP público opcional
- Configuração de discos de dados
- Identidade gerenciada
- Boot diagnostics
- Validações de entrada
- Exemplos de uso
- Documentação completa

### Security
- Validação de senhas com critérios de segurança
- NSG com regras mínimas necessárias
- Suporte para SSH keys no Linux
- Validação de nomes de usuário contra lista de reservados

### Documentation
- README detalhado
- Exemplos para Linux e Windows
- Documentação de inputs e outputs
- Guias de contribuição
