FOLDER:=n8n
install:
	# git clone https://github.com/hedgedoc/container.git ${FOLDER}
	mkdir ${FOLDER}
	ln -s $${PWD}/../.env ${FOLDER}/.env
	ln -s $${PWD}/docker-compose.yml ${FOLDER}/
	# @echo "Please do not forget to comment out the port lines in the hedgedoc/docker-compose.yml file"
#
clean:
	${MAKE} stop
	rm -Rf ${FOLDER}
update:
	cd ${FOLDER}; git pull
	${MAKE} start
start:
	cd ${FOLDER}; docker-compose --compatibility up -d
	${MAKE} logs
stop:
	cd ${FOLDER}; docker-compose --compatibility down

logs:
	cd ${FOLDER}; docker-compose --compatibility logs -f --tail 10