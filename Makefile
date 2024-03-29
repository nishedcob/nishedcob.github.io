
JINJA_IMAGE=nishedcob/nishedcob.github.io:templater
JEKYLL_IMAGE=nishedcob/nishedcob.github.io:dev
TEXLIVE_IMAGE=texlive/texlive:TL2020-historic

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
	$(MAKE) run_templater CMD="en_web" JINJA_IMAGE=$(JINJA_IMAGE)

## es/index.md |-| Build es/index.md
es/index.md: es.yaml universal.yaml index.md.j2
	$(MAKE) run_templater CMD="es_web" JINJA_IMAGE=$(JINJA_IMAGE)

## main.tex |-| Build main.tex
main.tex: en.yaml universal.yaml main.tex.j2
	$(MAKE) run_templater CMD="en_latex" JINJA_IMAGE=$(JINJA_IMAGE)


## es/main.tex |-| Build es/main.tex
es/main.tex: es.yaml universal.yaml main.tex.j2
	$(MAKE) run_templater CMD="es_latex" JINJA_IMAGE=$(JINJA_IMAGE)

## run_latex_builder |-| Run LaTeX Compiler Docker Image
run_latex_builder: CMD=""
run_latex_builder:
	docker run --rm -it --volume="$$PWD:/src/doc" $(TEXLIVE_IMAGE) /src/doc/latex_build.sh $(CMD)

## main.pdf |-| Build main.pdf
main.pdf: main.tex
	$(MAKE) run_latex_builder CMD="en" TEXLIVE_IMAGE=$(TEXLIVE_IMAGE)

## es/main.pdf |-| Build es/main.pdf
es/main.pdf: es/main.tex
	$(MAKE) run_latex_builder CMD="es" TEXLIVE_IMAGE=$(TEXLIVE_IMAGE)

## build_lang |-| Build a specific language (LANG)
build_lang:
	$(MAKE) run_templater CMD="$(LANG)" JINJA_IMAGE=$(JINJA_IMAGE)
	$(MAKE) run_latex_builder CMD="$(LANG)" TEXLIVE_IMAGE=$(TEXLIVE_IMAGE)

## lang_en |-| Build English files
lang_en:
	$(MAKE) build_lang LANG="en" JINJA_IMAGE=$(JINJA_IMAGE) TEXLIVE_IMAGE=$(TEXLIVE_IMAGE)

## lang_es |-| Build Spanish Files
lang_es:
	$(MAKE) build_lang LANG="es" JINJA_IMAGE=$(JINJA_IMAGE) TEXLIVE_IMAGE=$(TEXLIVE_IMAGE)

## ci |-| Build index.md, main.pdf, es/index.md and es/main.pdf
ci:
	$(MAKE) run_templater CMD="ci" JINJA_IMAGE=$(JINJA_IMAGE)
	$(MAKE) run_latex_builder CMD="ci" TEXLIVE_IMAGE=$(TEXLIVE_IMAGE)

## all |-| Build index.md, main.pdf, es/index.md and es/main.pdf
all:
	$(MAKE) run_templater CMD="all" JINJA_IMAGE=$(JINJA_IMAGE)
	$(MAKE) run_latex_builder CMD="all" TEXLIVE_IMAGE=$(TEXLIVE_IMAGE)

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
		echo "docker run -it --rm --volume=\"$$PWD:/srv/jekyll\" --publish '[::1]:4000:4000' --entrypoint /bin/bash $(JEKYLL_IMAGE)" ; \
		docker run -it --rm --volume="$$PWD:/srv/jekyll" --publish '[::1]:4000:4000' --entrypoint /bin/bash $(JEKYLL_IMAGE) ; \
	fi

## clean |-| Delete Development Docker Image
clean:
	docker rmi nishedcob/nishedcob.github.io:dev
