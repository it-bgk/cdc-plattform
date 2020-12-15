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
	cd ${FOLDER}; docker-compose --compatibility up -d
stop:
	cd ${FOLDER}; docker-compose --compatibility down