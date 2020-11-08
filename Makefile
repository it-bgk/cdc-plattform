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
