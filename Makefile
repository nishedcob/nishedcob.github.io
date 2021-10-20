
help:
	@echo "build - Build Development Docker Image"
	@echo "run   - Run Development Docker Image"
	@echo "clean - Delete Development Docker Image"

build:
	docker build -t nishedcob/nishedcob.github.io:dev .

run: build
	docker run --rm --volume="$$PWD:/srv/jekyll" --publish '[::1]:4000:4000' nishedcob/nishedcob.github.io:dev jekyll serve

clean:
	docker rmi nishedcob/nishedcob.github.io:dev
