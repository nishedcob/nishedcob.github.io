
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
	$(MAKE) run_templater CMD="en" JINJA_IMAGE=$(JINJA_IMAGE)

## es/index.md |-| Build es/index.md
es/index.md: es.yaml universal.yaml index.md.j2
	$(MAKE) run_templater CMD="es" JINJA_IMAGE=$(JINJA_IMAGE)

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
	docker build -t $(JEKYLL_IMAGE) .

## run |-| Run Development Docker Image
run: build
	docker run --rm --volume="$$PWD:/srv/jekyll" --publish '[::1]:4000:4000' $(JEKYLL_IMAGE) jekyll serve

## clean |-| Delete Development Docker Image
clean:
	docker rmi nishedcob/nishedcob.github.io:dev
