
help:
	@echo "build - Build Development Docker Image"
	@echo "run   - Run Development Docker Image"
	@echo "clean - Delete Development Docker Image"

build_templater:
	docker build --file Dockerfile.templater -t nishedcob/nishedcob.github.io:templater .

run_templater: CMD=""
run_templater: build_templater
	docker run --rm --volume="$$PWD:/usr/src/app" nishedcob/nishedcob.github.io:templater ./templater.sh $(CMD)

index.md: en.yaml universal.yaml index.md.j2
	$(MAKE) run_templater CMD="en"

es/index.md: es.yaml universal.yaml index.md.j2
	$(MAKE) run_templater CMD="es"

ci:
	$(MAKE) run_templater CMD="ci"

all:
	$(MAKE) run_templater CMD="all"

build:
	docker build -t nishedcob/nishedcob.github.io:dev .

run: build
	docker run --rm --volume="$$PWD:/srv/jekyll" --publish '[::1]:4000:4000' nishedcob/nishedcob.github.io:dev jekyll serve

clean:
	docker rmi nishedcob/nishedcob.github.io:dev
