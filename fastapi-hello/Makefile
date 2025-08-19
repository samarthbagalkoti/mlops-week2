IMAGE=fastapi-hello:latest

build:
	docker build -t $(IMAGE) .

run:
	docker run -p 8080:8080 $(IMAGE)

test:
	curl http://localhost:8080/healthz

