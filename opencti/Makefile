install:
	git clone https://github.com/OpenCTI-Platform/docker.git
	ln -s ${PWD}/../.env docker/.env
	ln -s ${PWD}/docker-compose.override.yml docker/
clean:
	rm -Rf docker
update:
	cd docker
	git pull
start:
	cd docker
	docker-compose --compatibility up -d