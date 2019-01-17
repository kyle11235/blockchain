

docker-compose -f docker-compose-simple.yaml up -d 2>&1

ORDER_ADDRESS="$1"
ORDER_PORT="$2"
CHANNEL_NAME="$3"

: ${CHANNEL_NAME:="mychannel"}

docker exec cli ./script.sh $ORDER_ADDRESS $ORDER_PORT $CHANNEL_NAME
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Test failed"
    exit 1
  fi
