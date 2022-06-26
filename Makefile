.PHONY: build
build:
	docker build --tag lambda-axum-example-build .
	docker run --detach --name lambda-axum-example-container lambda-axum-example-build
	mkdir -p dist/
	docker cp lambda-axum-example-container:/build/deploy.zip dist/
	docker rm lambda-axum-example-container

.PHONY: clean
clean:
	docker image rm lambda-axum-example-build
