FOLDER:=n8n
install:
	# git clone https://github.com/hedgedoc/container.git ${FOLDER}
	mkdir n8n
	ln -s $${PWD}/../.env ${FOLDER}/.env
	ln -s $${PWD}/docker-compose.yml ${FOLDER}/
	# @echo "Please do not forget to comment out the port lines in the hedgedoc/docker-compose.yml file"
backup:
	 cd ${FOLDER}; docker-compose exec database pg_dump hedgedoc -U hedgedoc > ../backup_hedgedoc_$(date +%F).sql
	 gzip backup_hedgedoc_$(date +%F).sql
restore-%:
	@echo "Try to restore the backup from date $*"
	cp 
	gunzip -k backup_hedgedoc_$*.sql.gz; mv backup_hedgedoc_$*.sql ${FOLDER}/
	cd ${FOLDER}; docker-compose up -d database
	cd ${FOLDER}; cat backup_hedgedoc_$*.sql | docker exec -i $(docker-compose ps -q database) psql -U hedgedoc
	${MAKE} start
#
clean:
	${MAKE} stop
	rm -Rf ${FOLDER}
update:
	cd ${FOLDER}; git pull
	${MAKE} start
start:
	cd ..; docker-compose up -d traefik
	cd ${FOLDER}; docker-compose --compatibility up -d
	${MAKE} logs
stop:
	cd ${FOLDER}; docker-compose --compatibility down

logs:
	cd ${FOLDER}; docker-compose --compatibility logs -f --tail 10