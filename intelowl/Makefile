FOLDER:=intelowl
install:
	git clone https://github.com/intelowlproject/IntelOwl.git ${FOLDER}
	#mv ${FOLDER}/.env ${FOLDER}/.env.orig
	ln -s $${PWD}/../.env ${FOLDER}/docker/.env
	ln -s $${PWD}/docker-compose.override.yml ${FOLDER}/docker/
	cd ${FOLDER}/docker; \
		cp env_file_app_template env_file_app; \
		cp env_file_postgres_template env_file_postgres; \
		cp env_file_integrations_template env_file_integrations
	cd ${FOLDER}; python start.py prod up
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
	docker exec -ti intel_owl_uwsgi python3 manage.py createsuperuser
	docker logs -f --tail 10 intel_owl_uwsgi

