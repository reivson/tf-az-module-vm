package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformVMLinuxBasic(t *testing.T) {
	t.Parallel()

	// Configurações do teste
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/linux-basic",
		Vars: map[string]interface{}{
			"resource_group_name": "rg-test-vm-linux",
			"location":           "East US",
			"vm_name":            "vm-test-linux",
			"admin_username":     "testuser",
			"admin_password":     "TestPassword123!",
			"create_public_ip":   true,
		},
	})

	// Limpar recursos no final do teste
	defer terraform.Destroy(t, terraformOptions)

	// Executar terraform init e apply
	terraform.InitAndApply(t, terraformOptions)

	// Validar outputs
	vmId := terraform.Output(t, terraformOptions, "vm_id")
	assert.NotEmpty(t, vmId)

	privateIp := terraform.Output(t, terraformOptions, "private_ip")
	assert.NotEmpty(t, privateIp)

	// Validar se a VM foi criada no Azure
	resourceGroupName := terraform.Output(t, terraformOptions, "vm_summary")
	assert.NotEmpty(t, resourceGroupName)
}

func TestTerraformVMWindowsWithDataDisk(t *testing.T) {
	t.Parallel()

	// Configurações do teste
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/windows-with-data-disk",
		Vars: map[string]interface{}{
			"resource_group_name": "rg-test-vm-windows",
			"location":           "East US",
			"vm_name":            "vm-test-windows",
			"admin_username":     "testadmin",
			"admin_password":     "TestWindowsPassword123!",
			"create_public_ip":   true,
			"os_disk_size_gb":    128,
			"data_disk_size_gb":  100,
		},
	})

	// Limpar recursos no final do teste
	defer terraform.Destroy(t, terraformOptions)

	// Executar terraform init e apply
	terraform.InitAndApply(t, terraformOptions)

	// Validar outputs
	vmId := terraform.Output(t, terraformOptions, "vm_id")
	assert.NotEmpty(t, vmId)

	identityPrincipalId := terraform.Output(t, terraformOptions, "identity_principal_id")
	assert.NotEmpty(t, identityPrincipalId)

	// Validar se os discos de dados foram criados
	dataDisks := terraform.OutputMap(t, terraformOptions, "data_disks")
	assert.NotEmpty(t, dataDisks["ids"])
}

func TestTerraformVMValidation(t *testing.T) {
	t.Parallel()

	// Teste de validação de entrada inválida
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/linux-basic",
		Vars: map[string]interface{}{
			"resource_group_name": "",
			"location":           "Invalid Location",
			"vm_name":            "invalid-vm-name-that-is-way-too-long-and-should-fail",
			"admin_username":     "admin", // Nome reservado
		},
	})

	// Este teste deve falhar na validação
	_, err := terraform.InitAndPlanE(t, terraformOptions)
	assert.Error(t, err, "Esperado erro de validação")
}

func TestAzureVMExists(t *testing.T) {
	t.Parallel()

	subscriptionID := ""
	resourceGroupName := "rg-test-vm-linux"
	vmName := "vm-test-linux"

	// Verificar se a VM existe no Azure (após criação)
	// Este teste deve ser executado após TestTerraformVMLinuxBasic
	exists := azure.VirtualMachineExists(t, vmName, resourceGroupName, subscriptionID)
	assert.True(t, exists, "VM deveria existir no Azure")
}
