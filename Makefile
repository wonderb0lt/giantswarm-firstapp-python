PROJECT = currentweather
REGISTRY = registry.giantswarm.io
USERNAME :=  $(shell swarm user)

docker-build:
	docker build -t $(REGISTRY)/$(USERNAME)/$(PROJECT) .

docker-run-redis:
	docker run --name=redis -d redis

docker-run:
	docker run --rm -ti -p 5000:5000 --link redis:redis $(REGISTRY)/$(USERNAME)/$(PROJECT)

docker-push: docker-build
	docker push $(REGISTRY)/$(USERNAME)/$(PROJECT)

docker-pull:
	docker pull $(REGISTRY)/$(USERNAME)/$(PROJECT)

swarm-up: docker-push
	swarm up swarm.json --var=username=$(USERNAME)
