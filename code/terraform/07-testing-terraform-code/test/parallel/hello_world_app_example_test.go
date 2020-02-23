package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"

	"github.com/gruntwork-io/terratest/modules/http-helper"
        "crypto/tls" 
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
	"time"
)

func TestHelloWorldAppExample(t *testing.T)  {

	t.Parallel()

	opts := &terraform.Options{
		// You should update this relative path to point at your
		// hello-world-app example directory!
		TerraformDir: "../../examples/hello-world-app/standalone",

		Vars: map[string]interface{}{
			"mysql_config": map[string]interface{}{
				"address": "mock-value-for-test",
				"port": 3306,
			},
			"environment": fmt.Sprintf("test-%s", random.UniqueId()),
		},
	}

	// Clean up everything at the end of the test
	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	albDnsName := terraform.OutputRequired(t, opts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)

	expectedStatus := 200
	//expectedBody := "<h1>Hello, World</h1>"
        serverText := "Hello, World"
        mysqlAddress := "mock-value-for-test"
        mysqlPort := 3306

        expectedBody := fmt.Sprintf("<h1>%s</h1>\n<p>DB address: %s</p>\n<p>DB port: %d</p>", serverText, mysqlAddress, mysqlPort)

	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetry(
		t,
		url,
                &tls.Config{},
		expectedStatus,
		expectedBody,
		maxRetries,
		timeBetweenRetries,
	)

}
