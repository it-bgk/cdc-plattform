#!/bin/bash
# https://github.com/ninoseki/mihari

# CMD Start
IMAGE="ninoseki/mihari"
CMD="docker run --rm -ti"
# Prefix which is removed
PREFIX="MIHARI_"
ALL_VARS="$(grep "${PREFIX}" .env|grep -v "^\#")"

for i in $ALL_VARS
do
    var2add=${i#"$PREFIX"}
    #echo "Modify var $i to $var2add"
    CMD+=" -e $i"
done

# CMD Suffix
CMD+=" $IMAGE"

# Update Image
echo "Update Image..." && docker pull "$IMAGE"
echo "---"
# Execute Command
echo "Start Application and execute command '$*'"
echo "---"
$CMD "$@"