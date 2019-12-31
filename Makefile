
help:
	@echo "build - Build Development Docker Image"
	@echo "run   - Run Development Docker Image"
	@echo "clean - Delete Development Docker Image"

build:
	docker build -t nishedcob/nishedcob.github.io:dev .

run: build
	docker run --rm nishedcob/nishedcob.github.io:dev

clean:
	docker rmi nishedcob/nishedcob.github.io:dev
