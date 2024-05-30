# Terraform Modules with Lambda & API Gateway in Go

### Requirements

- `terraform` - Recommended installation with [`tfswitch`](https://tfswitch.warrensbox.com/Install/)
- `go` - Recommended installation with [`g` (Go version manager)](https://github.com/stefanmaric/g#single-line-installation)

#### Make & deploy & demo app

1. `make init` - Install terraform dependencies
2. `make deploy` - Build Go binary for lambda and create cloud resources
3. In another terminal, `make tail` - tail CloudWatch logs
4. `make post` - Post to API Gateway endpoint
5. `make destroy` - Clean up ~ remove all resources
