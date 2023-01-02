
JINJA_IMAGE=nishedcob/nishedcob.github.io:templater
JEKYLL_IMAGE=nishedcob/nishedcob.github.io:dev

## help |-| Display this help message
help: Makefile
	@sed -n 's|^## ||p' $< | column --separator '|' --table

## build_templater |-| Build Jinja Templating Docker Image
build_templater:
	docker build --file Dockerfile.templater -t $(JINJA_IMAGE) .

## run_templater |-| Run Jinja Templating Docker Image
run_templater: CMD=""
run_templater: build_templater
	docker run --rm --volume="$$PWD:/usr/src/app" $(JINJA_IMAGE) ./templater.sh $(CMD)

## index.md |-| Build index.md
index.md: en.yaml universal.yaml index.md.j2
	$(MAKE) run_templater CMD="en" JINJA_IMAGE=$(JINJA_IMAGE)

## es/index.md |-| Build es/index.md
es/index.md: es.yaml universal.yaml index.md.j2
	$(MAKE) run_templater CMD="es" JINJA_IMAGE=$(JINJA_IMAGE)

## ci |-| Build index.md and es/index.md
ci:
	$(MAKE) run_templater CMD="ci" JINJA_IMAGE=$(JINJA_IMAGE)

## all |-| Build index.md and es/index.md
all:
	$(MAKE) run_templater CMD="all" JINJA_IMAGE=$(JINJA_IMAGE)

## build |-| Build Development Docker Image
build:
	@if [ "$$(uname -m)" = "aarch64" ] || [ "$$(uname -m)" = "arm64" ] ; then \
		echo "docker build -f Dockerfile.debian -t $(JEKYLL_IMAGE) ." ; \
		docker build -f Dockerfile.debian -t $(JEKYLL_IMAGE) . ; \
	else \
		echo "docker build -t $(JEKYLL_IMAGE) ." ; \
		docker build -t $(JEKYLL_IMAGE) . ; \
	fi

## run |-| Run Development Docker Image
run: build
	@if [ "$$(uname -m)" = "aarch64" ] || [ "$$(uname -m)" = "arm64" ] ; then \
		echo "docker run -p 8080:8080 --rm nishedcob/nishedcob.github.io:dev" ; \
		docker run -p 8080:8080 --rm nishedcob/nishedcob.github.io:dev ; \
	else \
		if [ -d env ] ; then \
			rm -rdvf env ; \
		fi ; \
		echo "docker run --rm --volume=\"$$PWD:/srv/jekyll\" --publish '[::1]:4000:4000' $(JEKYLL_IMAGE) jekyll serve" ; \
		docker run --rm --volume="$$PWD:/srv/jekyll" --publish '[::1]:4000:4000' $(JEKYLL_IMAGE) jekyll serve ; \
	fi

## shell |-| Run a Shell in the Development Docker Image
shell: build
	@if [ "$$(uname -m)" = "aarch64" ] || [ "$$(uname -m)" = "arm64" ] ; then \
		echo "docker run -it -p 8080:8080 --rm --entrypoint /bin/bash $(JEKYLL_IMAGE)" ; \
		docker run -it -p 8080:8080 --rm --entrypoint /bin/bash $(JEKYLL_IMAGE) ; \
	else \
		echo "docker run -it --rm --volume=\"$$PWD:/srv/jekyll\" --publish '[::1]:4000:4000' --entrypoint /bin/bash $(JEKYLL_IMAGE) jekyll serve" ; \
		docker run -it --rm --volume="$$PWD:/srv/jekyll" --publish '[::1]:4000:4000' --entrypoint /bin/bash $(JEKYLL_IMAGE) jekyll serve ; \
	fi

## clean |-| Delete Development Docker Image
clean:
	docker rmi nishedcob/nishedcob.github.io:dev
