FOLDER:=opencti
install:
	git clone https://github.com/OpenCTI-Platform/docker.git ${FOLDER}
	ln -s ${PWD}/../.env ${FOLDER}/.env
	ln -s ${PWD}/docker-compose.override.yml ${FOLDER}/
clean:
	make stop
	rm -Rf ${FOLDER}
update:
	cd ${FOLDER}; git pull
	make start
start:
	cd ..; docker-compose up -d traefik
	cd ${FOLDER}; docker-compose --compatibility up -d
	docker logs -f opencti_opencti_1
stop:
	cd ${FOLDER}; docker-compose --compatibility down