FOLDER:=watcher
install:
	git clone https://github.com/Felix83000/Watcher.git ${FOLDER}
	mv ${FOLDER}/.env ${FOLDER}/.env.orig
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
	docker logs -f --tail 10 watcher
stop:
	cd ${FOLDER}; docker-compose down
init:
	docker exec -ti watcher python manage.py migrate
	docker exec -ti watcher python manage.py createsuperuser
	docker exec -ti watcher python manage.py populate_db
	docker restart watcher
	docker logs -f --tail 10 watcher
