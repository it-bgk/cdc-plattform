#!/bin/bash
BASE="$PWD"
TIMESTAMP=$(date +%F-%H:%M-%Z)
DOCKER_MINEMELD_CMD="docker run --rm -ti --entrypoint="" -v minemeld_local:/opt/minemeld/local:ro -v $BASE/BACKUP/minemeld:/backup  paloaltonetworks/minemeld"


func_create_folder(){
    [ -d "$BASE/BACKUP/$1" ] || mkdir -p "$BASE/BACKUP/$1"
}

func_preparation(){
    func_create_folder minemeld
    func_create_folder cassandra
    func_create_folder elasticsearch
}

backup_minemeld(){
    # https://live.paloaltonetworks.com/t5/minemeld-discussions/minemeld-best-way-to-backup-and-move-config-to-new-image/td-p/120450
    BACKUP_FILE="/backup/$0_$TIMESTAMP.tar.gz"
    echo "stop minemeld docker..."
    docker stop minemeld
    echo "backup minemeld config..."
    $DOCKER_MINEMELD_CMD "tar -cvzf $BACKUP_FILE /opt/minemeld/local/config/ /opt/minemeld/local/prototypes/"
    echo "start minemeld docker..."
    docker start minemeld
}

# restore_minemeld(){
    # https://live.paloaltonetworks.com/t5/minemeld-discussions/minemeld-best-way-to-backup-and-move-config-to-new-image/td-p/120450
#     echo "Implement minemeld..."
#     docker-compose up -d minemeld
#     echo "Stop minemeld container..."
#     minemeld stop
#     echo "restore minemeld content..."
#     "$DOCKER_MINEMELD_CMD" tar -C / -xvzf /backup/backup.tar.gz
#     echo "start minemeld container"
#     minemeld start
# }

backup_es(){
    curl -XPUT 'http://elasticsearch:9200/_snapshot/cortex_backup/snapshot_1?wait_for_completion=true&pretty' -d '{"indices": "_all"}'
}

restore_es(){
    curl -XPOST 'http://elasticsearch:9200/_snapshot/cortex_backup/snapshot_1/_restore' -d '{"indices": "_all"}'
}

backup_cassandra(){
    BACKUP_FILE="/backup/$0_$TIMESTAMP"
    CONTAINER_NAME="thehive-cassandra"
	docker exec -ti "$CONTAINER_NAME" nodetool cleanup thehive
	docker exec -ti "$CONTAINER_NAME" nodetool snapshot thehive -t "${TIMESTAMP}"
	docker exec -ti "$CONTAINER_NAME" "tar cjf ${BACKUP_FILE}.tbz /var/lib/cassandra/data/thehive/*/snapshots/${TIMESTAMP}/"
    docker copy -a "$CONTAINER_NAME:${BACKUP_FILE}.tbz" "$BASE/BACKUP/cassandra/"
	docker exec -ti "$CONTAINER_NAME" "nodetool -h localhost -p 7199 clearsnapshot -t ${TIMESTAMP}"
}

restore_cassandra(){
    ls -la "$BASE/BACKUP/cassandra/"
    input -e "Which backupfile?" BACKUP_FILE
    docker cp -a "$BASE/BACKUP/cassandra/$BACKUP_FILE.tbz"  "cassandra:${BACKUP_FILE}.tbz"
    tar jxf /PATH/TO/backup.tbz -C /
	docker exec -ti cassandra "cd /var/lib/cassandra/data/thehive; for I in $(ls /var/lib/cassandra/data/thehive)  ; do cp /var/lib/cassandra/data/thehive/$I/snapshots/backup_name/* /var/lib/cassandra/data/thehive/$I/ ; done"
	docker exec -ti cassandra chown -R cassandra:cassandra /var/lib/cassandra/data/thehive
	docker restart cassandra
}

###
func_preparation
[ "$1" == "backup" ] && [ "$2" == "minemeld" ] && backup_minemeld
[ "$1" == "restore" ] && [ "$2" == "minemeld" ] && restore_minemeld

[ "$1" == "backup" ] && [ "$2" == "cassandra" ] && backup_cassandra
[ "$1" == "restore" ] && [ "$2" == "cassandra" ] && restore_cassandra
set -xv

echo "exit $0."