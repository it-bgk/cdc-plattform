install:
	docker-compose pull
	install-watcher
	install-opencti
install-watcher:
	make -C watcher install
install-opencti:
	make -C opencti install
start-main:
	docker-compose up -d
start-watcher:
	make -C watcher start
start-opencti:
	make -C opencti start

# DEV only
update-toc:
	docker run -v $(shell pwd)":/app" -w /app --rm -it sebdah/markdown-toc --replace README.md

####
init_es:
	./.helper/backup.sh init elasticsearch

backup_es:
	./.helper/backup.sh backup elasticsearch

restore_es:
	./.helper/backup.sh restore elasticsearch

cleanup_es:
	./.helper/backup.sh cleanup elasticsearch
	
status_es:
	./.helper/backup.sh status elasticsearch
	
backup_cassandra:
	./.helper/backup.sh backup cassandra

restore_cassandra:
	./.helper/backup.sh restore cassandra

backup_minemeld:
	./.helper/backup.sh backup minemeld
