
# prepare
start b/import org/create orderer.pem/create channel

# install
install fabric-samples 1.1 to /u02/app/
put f2b into fabric-samples

# housekeeping
cd /u02/app/fabric-samples/f2b && chmod +x *.sh
./clear.sh

# run
./start.sh ${ORDER_ADDRESS} ${ORDER_PORT} ${CHANNEL_NAME}

# test more
docker exec -it cli /bin/bash


