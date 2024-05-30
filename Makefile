instructions:
		cat README.md | grep "[0-9]\."

plan:
		$(MAKE) -C infrastructure plan

init:
		$(MAKE) -C infrastructure init

build:
		GOOS=linux go build -o bootstrap app/main.go

deploy:
		make build && $(MAKE) -C infrastructure apply

post:
		$(MAKE) -C infrastructure post

tail:
		$(MAKE) -C infrastructure tail

destroy:
		$(MAKE) -C infrastructure destroy
