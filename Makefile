
## help | Display this help message
help: Makefile
	@sed -n 's/^## //p' $< | column -ts '|'

## build | Build a Docker Image for local previewing of changes
build:
	@if [ "$$(uname -m)" = "aarch64" ] || [ "$$(uname -m)" = "arm64" ] ; then \
		echo "docker build -f Dockerfile.debian -t nishedcob/nishedcob.github.io:dev ." ; \
		docker build -f Dockerfile.debian -t nishedcob/nishedcob.github.io:dev . ; \
	else \
		echo "docker build -t nishedcob/nishedcob.github.io:dev ." ; \
		docker build -t nishedcob/nishedcob.github.io:dev . ; \
	fi

## run | Run the Local Preview (as a Docker Image)
run: build
	@if [ "$$(uname -m)" = "aarch64" ] || [ "$$(uname -m)" = "arm64" ] ; then \
		echo "docker run -p 8080:8080 --rm nishedcob/nishedcob.github.io:dev" ; \
		docker run -p 8080:8080 --rm nishedcob/nishedcob.github.io:dev ; \
	else \
		echo "docker run --rm --volume=\"$$PWD:/srv/jekyll\" --publish '[::1]:4000:4000' nishedcob/nishedcob.github.io:dev jekyll serve" ; \
		docker run --rm --volume="$$PWD:/srv/jekyll" --publish '[::1]:4000:4000' nishedcob/nishedcob.github.io:dev jekyll serve ; \
	fi

## shell | Spawn a Shell in the Local Preview (Docker Image)
shell: build
	@if [ "$$(uname -m)" = "aarch64" ] || [ "$$(uname -m)" = "arm64" ] ; then \
		echo "docker run -it -p 8080:8080 --rm --entrypoint /bin/bash nishedcob/nishedcob.github.io:dev" ; \
		docker run -it -p 8080:8080 --rm --entrypoint /bin/bash nishedcob/nishedcob.github.io:dev ; \
	else \
		echo "docker run -it --rm --volume=\"$$PWD:/srv/jekyll\" --publish '[::1]:4000:4000' --entrypoint /bin/bash nishedcob/nishedcob.github.io:dev jekyll serve" ; \
		docker run -it --rm --volume="$$PWD:/srv/jekyll" --publish '[::1]:4000:4000' --entrypoint /bin/bash nishedcob/nishedcob.github.io:dev jekyll serve ; \
	fi

## clean | Remove the Docker Image used for Local Previewing
clean:
	docker rmi nishedcob/nishedcob.github.io:dev
