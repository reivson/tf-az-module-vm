# Script PowerShell para validar disponibilidade de imagens Linux no Azure
# Uso: .\validate_images.ps1 -Location "East US"

param(
    [string]$Location = "East US"
)

Write-Host "===================================" -ForegroundColor Green
Write-Host "Validando imagens Linux no Azure" -ForegroundColor Green
Write-Host "Região: $Location" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green

# Função para verificar imagem
function Test-VMImage {
    param(
        [string]$Publisher,
        [string]$Offer,
        [string]$Sku,
        [string]$Distribution
    )
    
    Write-Host ""
    Write-Host "Verificando $Distribution ($Publisher`:$Offer`:$Sku)..." -ForegroundColor Yellow
    
    try {
        # Verificar se a imagem existe
        $result = az vm image list-skus `
            --location $Location `
            --publisher $Publisher `
            --offer $Offer `
            --query "[?name=='$Sku']" `
            --output json 2>$null | ConvertFrom-Json
        
        if ($result -and $result.Count -gt 0) {
            Write-Host "✅ $Distribution`: Disponível" -ForegroundColor Green
            
            # Pegar a versão mais recente
            try {
                $latest = az vm image list `
                    --location $Location `
                    --publisher $Publisher `
                    --offer $Offer `
                    --sku $Sku `
                    --all `
                    --query "[-1].version" `
                    --output tsv 2>$null
                
                if ($latest) {
                    Write-Host "   📦 Versão mais recente: $latest" -ForegroundColor Gray
                }
            }
            catch {
                Write-Host "   ⚠️ Não foi possível obter versão mais recente" -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "❌ $Distribution`: Não disponível" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "❌ $Distribution`: Erro ao verificar" -ForegroundColor Red
        Write-Host "   Erro: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Verificar se Azure CLI está instalado
try {
    $azVersion = az version 2>$null
    if (-not $azVersion) {
        throw "Azure CLI não encontrado"
    }
}
catch {
    Write-Host "❌ Azure CLI não está instalado!" -ForegroundColor Red
    Write-Host "📖 Instale em: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli" -ForegroundColor Blue
    exit 1
}

# Verificar se está logado no Azure
try {
    $account = az account show 2>$null | ConvertFrom-Json
    if (-not $account) {
        throw "Não está logado"
    }
    Write-Host "🔐 Logado como: $($account.user.name)" -ForegroundColor Blue
}
catch {
    Write-Host "❌ Não está logado no Azure!" -ForegroundColor Red
    Write-Host "📖 Execute: az login" -ForegroundColor Blue
    exit 1
}

Write-Host "🔍 Verificando disponibilidade das imagens..." -ForegroundColor Blue

# Ubuntu
Test-VMImage -Publisher "Canonical" -Offer "0001-com-ubuntu-server-focal" -Sku "20_04-lts-gen2" -Distribution "Ubuntu 20.04 LTS"
Test-VMImage -Publisher "Canonical" -Offer "0001-com-ubuntu-server-jammy" -Sku "22_04-lts-gen2" -Distribution "Ubuntu 22.04 LTS"

# CentOS
Test-VMImage -Publisher "OpenLogic" -Offer "CentOS" -Sku "8_5" -Distribution "CentOS 8.5"
Test-VMImage -Publisher "OpenLogic" -Offer "CentOS" -Sku "7_9" -Distribution "CentOS 7.9"

# Red Hat Enterprise Linux
Test-VMImage -Publisher "RedHat" -Offer "RHEL" -Sku "8-lvm" -Distribution "RHEL 8 LVM"
Test-VMImage -Publisher "RedHat" -Offer "RHEL" -Sku "9-lvm" -Distribution "RHEL 9 LVM"

# Oracle Linux
Test-VMImage -Publisher "Oracle" -Offer "Oracle-Linux" -Sku "ol85" -Distribution "Oracle Linux 8.5"
Test-VMImage -Publisher "Oracle" -Offer "Oracle-Linux" -Sku "ol86" -Distribution "Oracle Linux 8.6"

# SUSE Linux Enterprise Server
Test-VMImage -Publisher "SUSE" -Offer "sles-15-sp3" -Sku "gen2" -Distribution "SLES 15 SP3"
Test-VMImage -Publisher "SUSE" -Offer "sles-15-sp4" -Sku "gen2" -Distribution "SLES 15 SP4"

# Debian
Test-VMImage -Publisher "Debian" -Offer "debian-11" -Sku "11" -Distribution "Debian 11"
Test-VMImage -Publisher "Debian" -Offer "debian-10" -Sku "10" -Distribution "Debian 10"

# Rocky Linux
Test-VMImage -Publisher "erockyenterprisesoftwarefoundationinc1653071250513" -Offer "rockylinux" -Sku "rockylinux-8" -Distribution "Rocky Linux 8"

# AlmaLinux
Test-VMImage -Publisher "almalinux" -Offer "almalinux" -Sku "8-gen2" -Distribution "AlmaLinux 8"

Write-Host ""
Write-Host "===================================" -ForegroundColor Green
Write-Host "✅ Validação concluída!" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Dicas:" -ForegroundColor Yellow
Write-Host "   • Use apenas imagens marcadas como ✅ disponíveis" -ForegroundColor Gray
Write-Host "   • Algumas distribuições podem ter custos adicionais (RHEL, SLES)" -ForegroundColor Gray
Write-Host "   • Verifique a documentação para SKUs alternativos" -ForegroundColor Gray
Write-Host ""
Write-Host "📚 Para ver todas as imagens disponíveis:" -ForegroundColor Blue
Write-Host "   az vm image list --location `"$Location`" --output table" -ForegroundColor Gray
