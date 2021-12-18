
## help |-| Display this help message
help: Makefile
	@sed -n 's|^## ||p' $< | column --separator '|' --table

## build_templater |-| Build Jinja Templating Docker Image
build_templater:
	docker build --file Dockerfile.templater -t nishedcob/nishedcob.github.io:templater .

## run_templater |-| Run Jinja Templating Docker Image
run_templater: CMD=""
run_templater: build_templater
	docker run --rm --volume="$$PWD:/usr/src/app" nishedcob/nishedcob.github.io:templater ./templater.sh $(CMD)

## index.md |-| Build index.md
index.md: en.yaml universal.yaml index.md.j2
	$(MAKE) run_templater CMD="en"

## es/index.md |-| Build es/index.md
es/index.md: es.yaml universal.yaml index.md.j2
	$(MAKE) run_templater CMD="es"

## ci |-| Build index.md and es/index.md
ci:
	$(MAKE) run_templater CMD="ci"

## all |-| Build index.md and es/index.md
all:
	$(MAKE) run_templater CMD="all"

## build |-| Build Development Docker Image
build:
	docker build -t nishedcob/nishedcob.github.io:dev .

## run |-| Run Development Docker Image
run: build
	docker run --rm --volume="$$PWD:/srv/jekyll" --publish '[::1]:4000:4000' nishedcob/nishedcob.github.io:dev jekyll serve

## clean |-| Delete Development Docker Image
clean:
	docker rmi nishedcob/nishedcob.github.io:dev
