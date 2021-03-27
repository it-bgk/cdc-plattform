install-all:
	${MAKE} install traefik-reverse-proxy
	docker-compose pull
	docker-compose up -d
	${MAKE} install opencti
	${MAKE} install watcher
install-%:
	${MAKE} -C $* install
update-%:
	${MAKE} -C $* update
start-%:
	${MAKE} -C $* start
stop-%:
	${MAKE} -C $* stop
logs-%:
	${MAKE} -C $* logs
clean-%:
	${MAKE} -C $* clean
####
update-repo:
	./.helper/update.sh
####
init_es:
	./.helper/backup.sh init elasticsearch

backup:
	backup_es
	backup_cassandra
	backup_minemeld


restore_es:
	./.helper/backup.sh restore elasticsearch

cleanup_es:
	./.helper/backup.sh cleanup elasticsearch
	
status_es:
	./.helper/backup.sh status elasticsearch

backup_es:
	./.helper/backup.sh backup elasticsearch

backup_cassandra:
	./.helper/backup.sh backup cassandra

restore_cassandra:
	./.helper/backup.sh restore cassandra

backup_minemeld:
	./.helper/backup.sh backup minemeld

####
# DEV only
update-toc:
	docker run -v $(shell pwd)":/app" -w /app --rm -it sebdah/markdown-toc README.md --skip-headers 2 --replace
build-docker-thehive:
	docker-compose build thehive
build-docker-cortex:
	docker-compose build cortex
