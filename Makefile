instructions:
		cat README.md | grep "1\."

build:
		GOOS=linux go build hey-joe/main.go

deploy:
		make build && terraform apply -auto-approve

post:
		# shell equivalent:
		# curl -i "$(terraform output -raw base_url)/hey" -X POST -d '{"name":"joe"}' -H "Content-Type: application/json"
		BASE_URL="$(shell terraform output -raw base_url)"; curl -i "$$BASE_URL/hey" -X POST -d '{"name":"joe"}' -H "Content-Type: application/json"
