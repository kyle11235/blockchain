# byfn

        root@debian:/u02/app/fabric-samples/first-network# ./byfn.sh -m generate
        Generating certs and genesis block for with channel 'mychannel' and CLI timeout of '10' seconds and CLI delay of '3' seconds
        Continue? [Y/n] Y
        proceeding ...
        /u02/app/fabric-samples/first-network/../bin/cryptogen

        ##########################################################
        ##### Generate certificates using cryptogen tool #########
        ##########################################################
        + cryptogen generate --config=./crypto-config.yaml
        org1.example.com
        org2.example.com
        + res=0
        + set +x

        /u02/app/fabric-samples/first-network/../bin/configtxgen
        ##########################################################
        #########  Generating Orderer Genesis block ##############
        ##########################################################
        + configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
        2018-06-20 03:31:42.216 UTC [common/tools/configtxgen] main -> INFO 001 Loading configuration
        2018-06-20 03:31:42.225 UTC [msp] getMspConfig -> INFO 002 Loading NodeOUs
        2018-06-20 03:31:42.225 UTC [msp] getMspConfig -> INFO 003 Loading NodeOUs
        2018-06-20 03:31:42.225 UTC [common/tools/configtxgen] doOutputBlock -> INFO 004 Generating genesis block
        2018-06-20 03:31:42.225 UTC [common/tools/configtxgen] doOutputBlock -> INFO 005 Writing genesis block
        + res=0
        + set +x

        #################################################################
        ### Generating channel configuration transaction 'channel.tx' ###
        #################################################################
        + configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID mychannel
        2018-06-20 03:31:42.254 UTC [common/tools/configtxgen] main -> INFO 001 Loading configuration
        2018-06-20 03:31:42.263 UTC [common/tools/configtxgen] doOutputChannelCreateTx -> INFO 002 Generating new channel configtx
        2018-06-20 03:31:42.263 UTC [msp] getMspConfig -> INFO 003 Loading NodeOUs
        2018-06-20 03:31:42.263 UTC [msp] getMspConfig -> INFO 004 Loading NodeOUs
        2018-06-20 03:31:42.293 UTC [common/tools/configtxgen] doOutputChannelCreateTx -> INFO 005 Writing new channel tx
        + res=0
        + set +x

        #################################################################
        #######    Generating anchor peer update for Org1MSP   ##########
        #################################################################
        + configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP
        2018-06-20 03:31:42.323 UTC [common/tools/configtxgen] main -> INFO 001 Loading configuration
        2018-06-20 03:31:42.331 UTC [common/tools/configtxgen] doOutputAnchorPeersUpdate -> INFO 002 Generating anchor peer update
        2018-06-20 03:31:42.331 UTC [common/tools/configtxgen] doOutputAnchorPeersUpdate -> INFO 003 Writing anchor peer update
        + res=0
        + set +x

        #################################################################
        #######    Generating anchor peer update for Org2MSP   ##########
        #################################################################
        + configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID mychannel -asOrg Org2MSP
        2018-06-20 03:31:42.353 UTC [common/tools/configtxgen] main -> INFO 001 Loading configuration
        2018-06-20 03:31:42.361 UTC [common/tools/configtxgen] doOutputAnchorPeersUpdate -> INFO 002 Generating anchor peer update
        2018-06-20 03:31:42.362 UTC [common/tools/configtxgen] doOutputAnchorPeersUpdate -> INFO 003 Writing anchor peer update
        + res=0
        + set +x

        root@debian:/u02/app/fabric-samples/first-network# ./byfn.sh -m up
        Starting with channel 'mychannel' and CLI timeout of '10' seconds and CLI delay of '3' seconds
        Continue? [Y/n] Y
        proceeding ...
        2018-06-20 03:32:01.156 UTC [main] main -> INFO 001 Exiting.....
        LOCAL_VERSION=1.1.0
        DOCKER_IMAGE_VERSION=1.1.0
        Creating network "net_byfn" with the default driver
        Creating volume "net_orderer.example.com" with default driver
        Creating volume "net_peer0.org1.example.com" with default driver
        Creating volume "net_peer1.org1.example.com" with default driver
        Creating volume "net_peer0.org2.example.com" with default driver
        Creating volume "net_peer1.org2.example.com" with default driver
        Creating peer1.org2.example.com ... done
        Creating peer0.org1.example.com ... done
        Creating peer0.org2.example.com ... done
        Creating orderer.example.com    ... done
        Creating peer1.org1.example.com ... done
        Creating cli                    ... done

        ____    _____      _      ____    _____ 
        / ___|  |_   _|    / \    |  _ \  |_   _|
        \___ \    | |     / _ \   | |_) |   | |  
        ___) |   | |    / ___ \  |  _ <    | |  
        |____/    |_|   /_/   \_\ |_| \_\   |_|  

        Build your first network (BYFN) end-to-end test

        Channel name : mychannel
        Creating channel...
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
        CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
        CORE_PEER_LOCALMSPID=Org1MSP
        CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
        CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
        CORE_PEER_TLS_ENABLED=true
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
        CORE_PEER_ID=cli
        CORE_LOGGING_LEVEL=INFO
        CORE_PEER_ADDRESS=peer0.org1.example.com:7051
        + peer channel create -o orderer.example.com:7050 -c mychannel -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
        + res=0
        + set +x
        2018-06-20 03:32:06.159 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
        2018-06-20 03:32:06.201 UTC [channelCmd] InitCmdFactory -> INFO 002 Endorser and orderer connections initialized
        2018-06-20 03:32:06.448 UTC [main] main -> INFO 003 Exiting.....
        ===================== Channel "mychannel" is created successfully ===================== 

        Having all peers join the channel...
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
        CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
        CORE_PEER_LOCALMSPID=Org1MSP
        CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
        CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
        CORE_PEER_TLS_ENABLED=true
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
        CORE_PEER_ID=cli
        CORE_LOGGING_LEVEL=INFO
        CORE_PEER_ADDRESS=peer0.org1.example.com:7051
        + peer channel join -b mychannel.block
        + res=0
        + set +x
        2018-06-20 03:32:06.531 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
        2018-06-20 03:32:06.721 UTC [channelCmd] executeJoin -> INFO 002 Successfully submitted proposal to join channel
        2018-06-20 03:32:06.721 UTC [main] main -> INFO 003 Exiting.....
        ===================== peer0.org1 joined on the channel "mychannel" ===================== 

        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
        CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
        CORE_PEER_LOCALMSPID=Org1MSP
        CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
        CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
        CORE_PEER_TLS_ENABLED=true
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
        CORE_PEER_ID=cli
        CORE_LOGGING_LEVEL=INFO
        CORE_PEER_ADDRESS=peer1.org1.example.com:7051
        + peer channel join -b mychannel.block
        + res=0
        + set +x
        2018-06-20 03:32:09.796 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
        2018-06-20 03:32:10.116 UTC [channelCmd] executeJoin -> INFO 002 Successfully submitted proposal to join channel
        2018-06-20 03:32:10.116 UTC [main] main -> INFO 003 Exiting.....
        ===================== peer1.org1 joined on the channel "mychannel" ===================== 

        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
        CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
        CORE_PEER_LOCALMSPID=Org2MSP
        CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
        CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
        CORE_PEER_TLS_ENABLED=true
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
        CORE_PEER_ID=cli
        CORE_LOGGING_LEVEL=INFO
        CORE_PEER_ADDRESS=peer0.org2.example.com:7051
        + peer channel join -b mychannel.block
        + res=0
        + set +x
        2018-06-20 03:32:13.189 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
        2018-06-20 03:32:13.325 UTC [channelCmd] executeJoin -> INFO 002 Successfully submitted proposal to join channel
        2018-06-20 03:32:13.325 UTC [main] main -> INFO 003 Exiting.....
        ===================== peer0.org2 joined on the channel "mychannel" ===================== 

        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
        CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
        CORE_PEER_LOCALMSPID=Org2MSP
        CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
        CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
        CORE_PEER_TLS_ENABLED=true
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
        CORE_PEER_ID=cli
        CORE_LOGGING_LEVEL=INFO
        CORE_PEER_ADDRESS=peer1.org2.example.com:7051
        + peer channel join -b mychannel.block
        + res=0
        + set +x
        2018-06-20 03:32:16.399 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
        2018-06-20 03:32:16.630 UTC [channelCmd] executeJoin -> INFO 002 Successfully submitted proposal to join channel
        2018-06-20 03:32:16.630 UTC [main] main -> INFO 003 Exiting.....
        ===================== peer1.org2 joined on the channel "mychannel" ===================== 

        Updating anchor peers for org1...
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
        CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
        CORE_PEER_LOCALMSPID=Org1MSP
        CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
        CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
        CORE_PEER_TLS_ENABLED=true
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
        CORE_PEER_ID=cli
        CORE_LOGGING_LEVEL=INFO
        CORE_PEER_ADDRESS=peer0.org1.example.com:7051
        + peer channel update -o orderer.example.com:7050 -c mychannel -f ./channel-artifacts/Org1MSPanchors.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
        + res=0
        + set +x
        2018-06-20 03:32:19.699 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
        2018-06-20 03:32:19.720 UTC [channelCmd] update -> INFO 002 Successfully submitted channel update
        2018-06-20 03:32:19.720 UTC [main] main -> INFO 003 Exiting.....
        ===================== Anchor peers for org "Org1MSP" on "mychannel" is updated successfully ===================== 

        Updating anchor peers for org2...
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
        CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
        CORE_PEER_LOCALMSPID=Org2MSP
        CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
        CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
        CORE_PEER_TLS_ENABLED=true
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
        CORE_PEER_ID=cli
        CORE_LOGGING_LEVEL=INFO
        CORE_PEER_ADDRESS=peer0.org2.example.com:7051
        + peer channel update -o orderer.example.com:7050 -c mychannel -f ./channel-artifacts/Org2MSPanchors.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
        + res=0
        + set +x
        2018-06-20 03:32:22.815 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
        2018-06-20 03:32:22.840 UTC [channelCmd] update -> INFO 002 Successfully submitted channel update
        2018-06-20 03:32:22.840 UTC [main] main -> INFO 003 Exiting.....
        ===================== Anchor peers for org "Org2MSP" on "mychannel" is updated successfully ===================== 

        Installing chaincode on peer0.org1...
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
        CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
        CORE_PEER_LOCALMSPID=Org1MSP
        CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
        CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
        CORE_PEER_TLS_ENABLED=true
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
        CORE_PEER_ID=cli
        CORE_LOGGING_LEVEL=INFO
        CORE_PEER_ADDRESS=peer0.org1.example.com:7051
        + peer chaincode install -n mycc -v 1.0 -l golang -p github.com/chaincode/chaincode_example02/go/
        + res=0
        + set +x
        2018-06-20 03:32:25.912 UTC [chaincodeCmd] checkChaincodeCmdParams -> INFO 001 Using default escc
        2018-06-20 03:32:25.912 UTC [chaincodeCmd] checkChaincodeCmdParams -> INFO 002 Using default vscc
        2018-06-20 03:32:26.141 UTC [main] main -> INFO 003 Exiting.....
        ===================== Chaincode is installed on peer0.org1 ===================== 

        Install chaincode on peer0.org2...
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
        CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
        CORE_PEER_LOCALMSPID=Org2MSP
        CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
        CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
        CORE_PEER_TLS_ENABLED=true
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
        CORE_PEER_ID=cli
        CORE_LOGGING_LEVEL=INFO
        CORE_PEER_ADDRESS=peer0.org2.example.com:7051
        + peer chaincode install -n mycc -v 1.0 -l golang -p github.com/chaincode/chaincode_example02/go/
        + res=0
        + set +x
        2018-06-20 03:32:26.203 UTC [chaincodeCmd] checkChaincodeCmdParams -> INFO 001 Using default escc
        2018-06-20 03:32:26.203 UTC [chaincodeCmd] checkChaincodeCmdParams -> INFO 002 Using default vscc
        2018-06-20 03:32:26.417 UTC [main] main -> INFO 003 Exiting.....
        ===================== Chaincode is installed on peer0.org2 ===================== 

        Instantiating chaincode on peer0.org2...
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
        CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
        CORE_PEER_LOCALMSPID=Org2MSP
        CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
        CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
        CORE_PEER_TLS_ENABLED=true
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
        CORE_PEER_ID=cli
        CORE_LOGGING_LEVEL=INFO
        CORE_PEER_ADDRESS=peer0.org2.example.com:7051
        + peer chaincode instantiate -o orderer.example.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n mycc -l golang -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P 'OR    ('\''Org1MSP.peer'\'','\''Org2MSP.peer'\'')'
        + res=0
        + set +x
        2018-06-20 03:32:26.489 UTC [chaincodeCmd] checkChaincodeCmdParams -> INFO 001 Using default escc
        2018-06-20 03:32:26.489 UTC [chaincodeCmd] checkChaincodeCmdParams -> INFO 002 Using default vscc
        2018-06-20 03:32:38.570 UTC [main] main -> INFO 003 Exiting.....
        ===================== Chaincode Instantiation on peer0.org2 on channel 'mychannel' is successful ===================== 

        Querying chaincode on peer0.org1...
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
        CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
        CORE_PEER_LOCALMSPID=Org1MSP
        CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
        CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
        CORE_PEER_TLS_ENABLED=true
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
        CORE_PEER_ID=cli
        CORE_LOGGING_LEVEL=INFO
        CORE_PEER_ADDRESS=peer0.org1.example.com:7051
        ===================== Querying on peer0.org1 on channel 'mychannel'... ===================== 
        + peer chaincode query -C mychannel -n mycc -c '{"Args":["query","a"]}'
        Attempting to Query peer0.org1 ...3 secs
        + res=0
        + set +x

        2018-06-20 03:32:41.648 UTC [chaincodeCmd] checkChaincodeCmdParams -> INFO 001 Using default escc
        2018-06-20 03:32:41.648 UTC [chaincodeCmd] checkChaincodeCmdParams -> INFO 002 Using default vscc
        Query Result: 100
        2018-06-20 03:32:53.001 UTC [main] main -> INFO 003 Exiting.....
        ===================== Query on peer0.org1 on channel 'mychannel' is successful ===================== 
        Sending invoke transaction on peer0.org1...
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
        CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
        CORE_PEER_LOCALMSPID=Org1MSP
        CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
        CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
        CORE_PEER_TLS_ENABLED=true
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
        CORE_PEER_ID=cli
        CORE_LOGGING_LEVEL=INFO
        CORE_PEER_ADDRESS=peer0.org1.example.com:7051
        + peer chaincode invoke -o orderer.example.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n mycc -c '{"Args":["invoke","a","b","10"]}'
        + res=0
        + set +x
        2018-06-20 03:32:53.073 UTC [chaincodeCmd] checkChaincodeCmdParams -> INFO 001 Using default escc
        2018-06-20 03:32:53.073 UTC [chaincodeCmd] checkChaincodeCmdParams -> INFO 002 Using default vscc
        2018-06-20 03:32:53.086 UTC [chaincodeCmd] chaincodeInvokeOrQuery -> INFO 003 Chaincode invoke successful. result: status:200 
        2018-06-20 03:32:53.087 UTC [main] main -> INFO 004 Exiting.....
        ===================== Invoke transaction on peer0.org1 on channel 'mychannel' is successful ===================== 

        Installing chaincode on peer1.org2...
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
        CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
        CORE_PEER_LOCALMSPID=Org2MSP
        CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
        CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
        CORE_PEER_TLS_ENABLED=true
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
        CORE_PEER_ID=cli
        CORE_LOGGING_LEVEL=INFO
        CORE_PEER_ADDRESS=peer1.org2.example.com:7051
        + peer chaincode install -n mycc -v 1.0 -l golang -p github.com/chaincode/chaincode_example02/go/
        + res=0
        + set +x
        2018-06-20 03:32:53.148 UTC [chaincodeCmd] checkChaincodeCmdParams -> INFO 001 Using default escc
        2018-06-20 03:32:53.148 UTC [chaincodeCmd] checkChaincodeCmdParams -> INFO 002 Using default vscc
        2018-06-20 03:32:53.357 UTC [main] main -> INFO 003 Exiting.....
        ===================== Chaincode is installed on peer1.org2 ===================== 

        Querying chaincode on peer1.org2...
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
        CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
        CORE_PEER_LOCALMSPID=Org2MSP
        CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
        CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
        CORE_PEER_TLS_ENABLED=true
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
        CORE_PEER_ID=cli
        CORE_LOGGING_LEVEL=INFO
        CORE_PEER_ADDRESS=peer1.org2.example.com:7051
        ===================== Querying on peer1.org2 on channel 'mychannel'... ===================== 
        Attempting to Query peer1.org2 ...3 secs
        + peer chaincode query -C mychannel -n mycc -c '{"Args":["query","a"]}'
        + res=0
        + set +x

        2018-06-20 03:32:56.436 UTC [chaincodeCmd] checkChaincodeCmdParams -> INFO 001 Using default escc
        2018-06-20 03:32:56.436 UTC [chaincodeCmd] checkChaincodeCmdParams -> INFO 002 Using default vscc
        Query Result: 90
        2018-06-20 03:33:08.086 UTC [main] main -> INFO 003 Exiting.....
        ===================== Query on peer1.org2 on channel 'mychannel' is successful ===================== 

        ========= All GOOD, BYFN execution completed =========== 


        _____   _   _   ____   
        | ____| | \ | | |  _ \  
        |  _|   |  \| | | | | | 
        | |___  | |\  | | |_| | 
        |_____| |_| \_| |____/  

        root@debian:/u02/app/fabric-samples/first-network#