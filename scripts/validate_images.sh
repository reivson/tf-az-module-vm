#!/bin/bash

# Script para validar disponibilidade de imagens Linux no Azure
# Uso: ./validate_images.sh [location]

LOCATION=${1:-"East US"}

echo "==================================="
echo "Validando imagens Linux no Azure"
echo "Região: $LOCATION"
echo "==================================="

# Função para verificar imagem
check_image() {
    local publisher=$1
    local offer=$2
    local sku=$3
    local distribution=$4
    
    echo ""
    echo "Verificando $distribution ($publisher:$offer:$sku)..."
    
    # Verificar se a imagem existe
    result=$(az vm image list-skus \
        --location "$LOCATION" \
        --publisher "$publisher" \
        --offer "$offer" \
        --query "[?name=='$sku']" \
        --output tsv 2>/dev/null)
    
    if [ -n "$result" ]; then
        echo "✅ $distribution: Disponível"
        
        # Pegar a versão mais recente
        latest=$(az vm image list \
            --location "$LOCATION" \
            --publisher "$publisher" \
            --offer "$offer" \
            --sku "$sku" \
            --all \
            --query "[-1].version" \
            --output tsv 2>/dev/null)
        
        if [ -n "$latest" ]; then
            echo "   📦 Versão mais recente: $latest"
        fi
    else
        echo "❌ $distribution: Não disponível"
    fi
}

# Verificar se Azure CLI está instalado
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI não está instalado!"
    echo "📖 Instale em: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Verificar se está logado no Azure
if ! az account show &> /dev/null; then
    echo "❌ Não está logado no Azure!"
    echo "📖 Execute: az login"
    exit 1
fi

echo "🔍 Verificando disponibilidade das imagens..."

# Ubuntu
check_image "Canonical" "0001-com-ubuntu-server-focal" "20_04-lts-gen2" "Ubuntu 20.04 LTS"
check_image "Canonical" "0001-com-ubuntu-server-jammy" "22_04-lts-gen2" "Ubuntu 22.04 LTS"

# CentOS
check_image "OpenLogic" "CentOS" "8_5" "CentOS 8.5"
check_image "OpenLogic" "CentOS" "7_9" "CentOS 7.9"

# Red Hat Enterprise Linux
check_image "RedHat" "RHEL" "8-lvm" "RHEL 8 LVM"
check_image "RedHat" "RHEL" "9-lvm" "RHEL 9 LVM"

# Oracle Linux
check_image "Oracle" "Oracle-Linux" "ol85" "Oracle Linux 8.5"
check_image "Oracle" "Oracle-Linux" "ol86" "Oracle Linux 8.6"

# SUSE Linux Enterprise Server
check_image "SUSE" "sles-15-sp3" "gen2" "SLES 15 SP3"
check_image "SUSE" "sles-15-sp4" "gen2" "SLES 15 SP4"

# Debian
check_image "Debian" "debian-11" "11" "Debian 11"
check_image "Debian" "debian-10" "10" "Debian 10"

# Rocky Linux
check_image "erockyenterprisesoftwarefoundationinc1653071250513" "rockylinux" "rockylinux-8" "Rocky Linux 8"

# AlmaLinux
check_image "almalinux" "almalinux" "8-gen2" "AlmaLinux 8"

echo ""
echo "==================================="
echo "✅ Validação concluída!"
echo "==================================="
echo ""
echo "💡 Dicas:"
echo "   • Use apenas imagens marcadas como ✅ disponíveis"
echo "   • Algumas distribuições podem ter custos adicionais (RHEL, SLES)"
echo "   • Verifique a documentação para SKUs alternativos"
echo ""
echo "📚 Para ver todas as imagens disponíveis:"
echo "   az vm image list --location \"$LOCATION\" --output table"
