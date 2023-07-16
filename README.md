# Learn Terraform Modules with Lambda functions & API Gateway in Go

### Prerequisites
- `terraform` - Recommended installation with [`tfswitch`](https://tfswitch.warrensbox.com/Install/)
- `go` - Recommended installation with [`g` (Go version manager)](https://github.com/stefanmaric/g#single-line-installation)

Make and deploy app
1. `make build` - build Go binary for lambda
1. `terraform init` - install TF dependencies
1. `terraform apply -auto-approve` - create, deploy resources
1. `make post` - post to new endpoint

Clean up resources
- `terraform destroy` - remove all resources
