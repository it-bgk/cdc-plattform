FOLDER:=watcher
install:
	git clone https://github.com/Felix83000/Watcher.git ${FOLDER}
	mv ${FOLDER}/.env ${FOLDER}/.env.orig
	ln -s $${PWD}/../.env ${FOLDER}/.env
	ln -s $${PWD}/docker-compose.override.yml ${FOLDER}/
init:
	docker exec -ti watcher python manage.py migrate
	docker exec -ti watcher python manage.py createsuperuser
	docker exec -ti watcher python manage.py populate_db
	docker restart watcher
	${MAKE} logs
#
clean:
	${MAKE} stop
	rm -Rf ${FOLDER}
update:
	cd ${FOLDER}; git pull
	${MAKE} start
start:
	cd ${FOLDER}; docker-compose up -d
	${MAKE} logs
stop:
	cd ${FOLDER}; docker-compose down
logs:
	cd ${FOLDER}; docker-compose logs -f --tail 10
