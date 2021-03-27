FOLDER:=.
install:
	ln -s $${PWD}/../.env ${FOLDER}/.env
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