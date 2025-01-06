all: build

build:
	@docker build --tag=man1234/dockersquid .
