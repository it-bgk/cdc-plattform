FOLDER:=opencti
install:
	git clone https://github.com/OpenCTI-Platform/docker.git ${FOLDER}
	ln -s $${PWD}/../.env ${FOLDER}/.env
	ln -s $${PWD}/docker-compose.override.yml ${FOLDER}/
#
clean:
	${MAKE} stop
	rm -Rf ${FOLDER}
update:
	cd ${FOLDER}; git pull
	${MAKE} start
start:
	cd ..; docker-compose up -d traefik
	cd ${FOLDER}; docker-compose --compatibility up -d
	${MAKE} log
stop:
	cd ${FOLDER}; docker-compose --compatibility down

logs:
	cd ${FOLDER}; docker-compose --compatibility logs -f --tail 10