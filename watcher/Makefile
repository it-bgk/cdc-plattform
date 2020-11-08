install:
	git clone https://github.com/Felix83000/Watcher.git
	rm Watcher/.env
	ln -s ${PWD}/../.env Watcher/.env
	ln -s ${PWD}/docker-compose.override.yml Watcher/
cleanup:
	rm -Rf Watcher
update:
	cd Watcher
	git pull
start:
	cd Watcher
	docker-compose up -d