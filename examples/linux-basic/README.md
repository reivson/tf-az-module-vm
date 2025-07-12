# Exemplo: VM Linux Básica

Este exemplo demonstra como criar uma VM Linux básica usando o módulo.

## Recursos Criados

- VM Linux Ubuntu 20.04 LTS
- Network Interface
- Network Security Group com regra SSH
- IP público (opcional)

## Como usar

1. Configure as variáveis no arquivo `terraform.tfvars`
2. Execute os comandos:

```bash
terraform init
terraform plan
terraform apply
```

## Limpeza

```bash
terraform destroy
```

## Conectar à VM

Após a criação, use o comando SSH fornecido no output:

```bash
ssh azureuser@<public_ip>
```
