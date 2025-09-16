# Configure desired versions of terraform, azurerm provider
terraform {
  required_version = ">= 1.1.7, < 2.0.0"
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~>4.7.1"
    }
  }
}

provider "grafana" {
  url = var.grafana_endpoint
}
