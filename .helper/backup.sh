#!/bin/bash
BASE="$PWD"
TIMESTAMP=$(date +%F-%H:%M-%Z)
DOCKER_MINEMELD_CMD="docker run --rm -ti --entrypoint="" -v minemeld_local:/opt/minemeld/local:ro -v $BASE/BACKUP/minemeld:/backup  paloaltonetworks/minemeld"
DOCKER_ELASTICSEARCH_CMD="docker exec -ti elasticsearch"

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

init_elasticsearch(){
    $DOCKER_ELASTICSEARCH_CMD curl -X PUT "http://localhost:9200/_snapshot/backup?pretty" \
        -H 'Content-Type: application/json' -d '{
            "type": "fs",
            "settings": {
                "location": "/backup",
                "compress": true
            }
        }'

    # $DOCKER_ELASTICSEARCH_CMD curl -X PUT "localhost:9200/_slm/policy/daily-snapshots?pretty" \
    #     -u admin:admin --insecure \
    #     -H 'Content-Type: application/json' -d'
    #         {
    #         "schedule": "0 30 1 * * ?", 
    #         "name": "daily-snap-{now/d}", 
    #         "repository": "backup", 
    #         "config": { 
    #             "indices": ["*"], 
    #             "ignore_unavailable": false,
    #             "include_global_state": true
    #         },
    #         "retention": { 
    #             "expire_after": "30d", 
    #             "min_count": 5, 
    #             "max_count": 50 
    #         }
    #     }
    #     '
}

status_elasticsearch(){
    $DOCKER_ELASTICSEARCH_CMD curl -X GET "localhost:9200/_snapshot/_all?human&pretty"
    #$DOCKER_ELASTICSEARCH_CMD curl -X GET "localhost:9200/_slm/policy/daily-snapshots?human&pretty" -u admin:admin --insecure
    $DOCKER_ELASTICSEARCH_CMD curl -X GET "localhost:9200/_snapshot/_status?human&pretty"
}

cleanup_elasticsearch(){
    $DOCKER_ELASTICSEARCH_CMD curl -X POST "localhost:9200/_snapshot/backup/_cleanup?pretty"
}

backup_elasticsearch(){
    #$DOCKER_ELASTICSEARCH_CMD curl -X POST "localhost:9200/_slm/policy/daily-snapshots/_execute?pretty"
    #$DOCKER_ELASTICSEARCH_CMD curl -X PUT "localhost:9200/_snapshot/backup/<snapshot-{now/d}>?pretty"
    $DOCKER_ELASTICSEARCH_CMD curl -X PUT "localhost:9200/_snapshot/backup/%3Csnapshot-%7Bnow%2Fd%7D%3E?pretty"
    $DOCKER_ELASTICSEARCH_CMD  curl -X PUT "localhost:9200/_snapshot/backup/%3Csnapshot-%7Bnow%2Fd%7D%3E?wait_for_completion=true&pretty" -H 'Content-Type: application/json' -d'
    {
        "indices": "_all",
        "ignore_unavailable": true,
        "include_global_state": true,
        "metadata": {
            "taken_by": "backup_script",
            "taken_because": "daily backup"
        }
    }
    '


}

restore_elasticsearch(){
    docker-compose up -d elasticsearch
    read -rp "Press Enter to continue..."
    init_elasticsearch

    echo "Print all current snapshots:"
    $DOCKER_ELASTICSEARCH_CMD curl -X GET 'http://elasticsearch:9200/_snapshot/backup/_all?pretty'|grep '"snapshot" : "'| cut -d : -f 2|cut -d \' -f 1
    #$DOCKER_ELASTICSEARCH_CMD curl -X GET 'http://elasticsearch:9200/_snapshot/backup/_status'
    set -xv
    read -rp "Snapshot to restore: " RESTORE_POINT

    #shellcheck disable=SC2016
    $DOCKER_ELASTICSEARCH_CMD curl -X POST \
        "http://elasticsearch:9200/_snapshot/backup/$RESTORE_POINT/_restore" \
        -H "Content-Type: application/json" -d '{
            "indices": "_all",
            "ignore_unavailable": true,
            "include_global_state": true,
            "rename_pattern": "index_(.+)",
            "rename_replacement": "restored_index_$1",
            "include_aliases": false
            }'
    $DOCKER_ELASTICSEARCH_CMD curl -X GET 'http://elasticsearch:9200/_snapshot/backup/_status'
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
set -x
[ "$1" != "" ] && [ "$2" != "" ] && "$1_$2"  && exit 0

echo "exit $0."