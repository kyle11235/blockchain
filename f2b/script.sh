#!/bin/bash
set -e

echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echo
echo "f2b end-to-end test"
echo

ORDER_ADDRESS="$1"
ORDER_PORT="$2"
CHANNEL_NAME="$3"
: ${CHANNEL_NAME:="mychannel"}
CC_SRC_PATH="f2b/chaincode/chaincode_example02/go"
CC_NAME="myc"
ORDERER_CA="/opt/gopath/src/f2b/orderer.pem"


echo "order address: "$ORDER_ADDRESS
echo "order port: "$ORDER_PORT
echo "channel name: "$CHANNEL_NAME
echo "chaincode path: "$CC_SRC_PATH
echo "chaincode name: "$CC_NAME
echo

echo "fetch channel block..."
peer channel fetch 0 ${CHANNEL_NAME}.block -o ${ORDER_ADDRESS}:${ORDER_PORT} -c ${CHANNEL_NAME} --tls --cafile $ORDERER_CA --logging-level debug

echo "join the channel..."
peer channel join -b ${CHANNEL_NAME}.block -o ${ORDER_ADDRESS}:${ORDER_PORT} --tls --cafile $ORDERER_CA --logging-level debug

echo "install"
peer chaincode install -n $CC_NAME -v 1.0 -l "golang" -p ${CC_SRC_PATH}

echo "instantiate"
peer chaincode instantiate -o ${ORDER_ADDRESS}:${ORDER_PORT} --tls --cafile $ORDERER_CA -C ${CHANNEL_NAME} -n $CC_NAME -l golang -v 1.0 -c '{"Args":["init","a","100","b","200"]}' --logging-level debug

sleep 10

echo "invoke"
peer chaincode invoke -o ${ORDER_ADDRESS}:${ORDER_PORT}  --tls --cafile $ORDERER_CA -C ${CHANNEL_NAME} -n $CC_NAME -c '{"Args":["invoke","a","b","10"]}' --logging-level debug

echo "query"
peer chaincode query -C ${CHANNEL_NAME} -n $CC_NAME -c '{"Args":["query","a"]}'  --logging-level debug

echo
echo "========= execution completed =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

exit 0
