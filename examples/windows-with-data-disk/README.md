# Exemplo: VM Windows com Disco Adicional

Este exemplo demonstra como criar uma VM Windows com discos de dados adicionais.

## Recursos Criados

- VM Windows Server 2022
- Network Interface
- Network Security Group com regra RDP
- IP público
- Disco de dados adicional (100GB)

## Como usar

1. Configure as variáveis no arquivo `terraform.tfvars`
2. Execute os comandos:

```bash
terraform init
terraform plan
terraform apply
```

## Conectar à VM

Use Remote Desktop Connection:
- IP: Veja o output `public_ip`
- Usuário: Veja o output `admin_username`
- Senha: A que você configurou no `terraform.tfvars`
