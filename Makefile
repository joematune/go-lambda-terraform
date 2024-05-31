instructions:
		cat README.md | grep "[0-9]\."

plan:
		$(MAKE) -C infrastructure plan

init:
		$(MAKE) -C infrastructure init

build:
		GOOS=linux go build -o builds/api-lambda/bootstrap app/api-lambda/main.go && \
		GOOS=linux go build -o builds/sqs-lambda/bootstrap app/sqs-lambda/main.go

deploy:
		make build && $(MAKE) -C infrastructure apply

post:
		$(MAKE) -C infrastructure post

tail_api:
		$(MAKE) -C infrastructure tail_api

send:
		$(MAKE) -C infrastructure send

tail_sqs:
		$(MAKE) -C infrastructure tail_sqs

destroy:
		$(MAKE) -C infrastructure destroy
