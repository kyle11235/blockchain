# fabric

- getting started

        1)	install docker(oracle linux docker=X, binary docker=Y)/docker compose/git 
        2)	download fabric binaries (it downloads docker images and samples)
            https://hyperledger-fabric.readthedocs.io/en/release-1.1/samples.htm is wrong guide

            sudo -i
            mkdir -p /u02/app && cd /u02/app

            curl -sSL https://goo.gl/6wtTN5 | bash -s 1.1.0  1.1.0  0.4.6
            (fabric-version ca-version baseimage-version)

            vi /etc/profile
            export FABRIC_PATH=/u02/app/fabric-samples
            export PATH=$PATH:$FABRIC_PATH/bin
            source /etc/profile

            it comes with fabric-samples

        3)	(optional) install go if you want to write go chaincode
            fabric’s chaincode requires to set GOPATH=$HOME/go

        4)	(optional) install node/npm if you want to try node SDK
            node is v6.9.5, npm is v3.10.10

        5)	(optional) install python for npm install to complete successfully to use node SDK
            sudo apt-get install python
            python --version

- Build your first network

        1)	end to end demo by script byfn.sh
            
            sudo -i
            cd /u02/app/fabric-examples/first-network

            ./byfn.sh -m generate
            ./byfn.sh -m up
            ./byfn.sh -m down (run this after test, to clean env for other tests)

            general steps are like these:

            step1 - prepare materials:
            •	Generate certificates using cryptogen tool
            •	Generating Orderer Genesis block
            •	Generating channel configuration transaction 'channel.tx'
            •	Generating anchor peer update for Org1MSP
            •	Generating anchor peer update for Org2MSP

            step2 - create channel
            •	Channel "mychannel" is created successfully
            •	peer0.org1 joined on the channel "mychannel"
            •	peer1.org1 joined on the channel "mychannel"
            •	peer0.org2 joined on the channel "mychannel"
            •	peer1.org2 joined on the channel "mychannel"
            •	Anchor peers for org "Org1MSP" on "mychannel" is updated successfully
            •	Anchor peers for org "Org2MSP" on "mychannel" is updated successfully

            step3 - install chaincode:
            •	Chaincode is installed on peer0.org1
            •	Chaincode is installed on peer0.org2
            •	Chaincode Instantiation on peer0.org2 on channel 'mychannel' is successful
            •	Query on peer0.org1 on channel 'mychannel' is successful
            •	Invoke transaction on peer0.org1 on channel 'mychannel' is successful

            •	Chaincode is installed on peer1.org2
            •	Query on peer1.org2 on channel 'mychannel' is successful

            •	All GOOD, BYFN execution completed

        2)	step by step manually
            
            •	understand tool1 - Crypto Generator

                it prepares MSP
                ./byfn.sh -m generate

                We will use the cryptogen tool to generate the cryptographic material (x509 certs and signing keys) for our various network entities. These certificates are representative of identities, and they allow for sign/verify authentication to take place as our entities communicate and transact.

                cryptogen consumes crypto-config.yaml, which defines a typical network.
                1 org === 1 member

                results are saved into ./crypto-config folder:

            •	run Crypto Generator manually

                ../bin/cryptogen generate --config=./crypto-config.yaml

            •	understand tool2 - Configuration Transaction Generator

                it prepares orderer’s genesis block & channel.tx & anchorPeer.tx

                configtxgen consumes configtx.yaml that contains the definations of the sample network.

                configtx.yaml tells where the certificates for each MSP are, allowing us to store the root certificate for each Org in the orderer genesis block, then the communication between orderer and peers can have its digital signature verified.

                results are saved into ./channel-artifacts

            •	run Configuration Transaction Generator manually

                # tell where the configtx.yaml is
                export FABRIC_CFG_PATH=${PWD} 

                # prepare orderer generis block
                ../bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

                # prepare a channel tx artifact
                export CHANNEL_NAME=mychannel  && ../bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

                # prepare anchor peer for org1
                ../bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

                # prepare anchor peer for org2
                ../bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP

            •	understand docker-compose-cli.yaml (real workers who consume prepared artifacts):

                The network will be started leveraging docker-compose-cli.yaml
                check the networkUp function of byfn.sh

                5 peer network containers defined in docker-compose-cli.yaml
                orderer.example.com
                peer0.org1.example.com
                peer1.org1.example.com
                peer0.org2.example.com
                peer1.org2.example.com

                1 Cli container that mounts all the prepared configs/artifacts/chaincode, it will help connect all the containers together

                - start network containers
                docker-compose -f $COMPOSE_TILE up -d 2>&1

                - operate network
                docker exec cli scripts/script.sh
            
            •	start the network containers manually

                docker-compose -f docker-compose-cli.yaml up -d
                
                the cli container will be up for 1000 seconds, you can restart it with:
                docker start cli
                export CHANNEL_NAME=mychannel

            •	understand the scripts.sh

                the function will login the cli container & call the mounted ./scripts/script.sh, the script will …
                1)	create channel
                2)	join peers to channel
                3)	update channel’s anchor peer
                4)	install chaincode & instantiate chaincode

            •	run the steps of scripts.sh manually

                1. login cli container
                
                    docker exec -it cli bash

                2. create channel

                    export CHANNEL_NAME=mychannel

                    peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

                    this command returns channel-ID.block which we will use to join the channel.

                    - before do anything further, set environment variables for the peer you operate first.
                    
                    setEnv:
                    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/$ORG.example.com/users/Admin@$ORG.example.com/msp
                    CORE_PEER_ADDRESS=$PEER.$ORG.example.com:7051
                    CORE_PEER_LOCALMSPID="$MSPID"
                    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/$ORG.example.com/peers/$PEER.$ORG.example.com/tls/ca.crt

                    join peer0 of org1 to channel:
                    PEER=peer0
                    ORG=org1
                    MSPID=Org1MSP

                    setEnv…
                    peer channel join -b mychannel.block
                    (this is returned by creation of channel)

                    join peer1 of org1…
                    PEER=peer1
                    ORG=org1
                    MSPID=Org1MSP

                    setEnv…
                    peer channel join -b mychannel.block

                    join peer0 of org2 to channel:
                    PEER=peer0
                    ORG=org2
                    MSPID=Org2MSP

                    setEnv…
                    peer channel join -b mychannel.block

                    join peer1 of org2…
                    PEER=peer1
                    ORG=org2
                    MSPID=Org2MSP

                    setEnv…
                    peer channel join -b mychannel.block

                    update the channel to define the anchor peer of org1 as peer0.org1.example.com
                    PEER=peer0
                    ORG=org1
                    MSPID=Org1MSP

                    setEnv…
                    peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

                    update the channel to define the anchor peer of org1 as peer0.org2.example.com
                    PEER=peer0
                    ORG=org2
                    MSPID=Org1MSP

                    setEnv…
                    peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org2MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

                3. install chaincode to peers

                    Applications interact with the blockchain ledger through chaincode. As such we need to install the chaincode on every peer that will execute and endorse(invoke/query/endorse) our transactions, and then instantiate the chaincode on the channel.

                    For golang only below relative path is valid because GOPATH(/opt/gopath) will be used as prefix.
                    PEER=peer0
                    ORG=org1
                    MSPID=Org1MSP

                    setEnv…
                    peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/chaincode_example02/go/

                4. instantiate chaincode on the channel

                    peer chaincode instantiate -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n mycc -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}' -P "OR ('Org1MSP.peer','Org2MSP.peer')"

                5. endorsement policy

                    param -P means that we need “endorsement” from a peer belonging to Org1 OR Org2 (i.e. only one endorsement).
                   
                    A chaincode container will be launched asap when init/query/invoke
                   
                    If you want additional peers to interact with ledger:
                    then you will need to join them to the channel, and install the same name, version and language of the chaincode source onto the appropriate peer’s filesystem. A chaincode container will be launched for each peer as soon as they try to interact with that specific chaincode.

                6. verify with cli container

                    query (on peer that installed chaincode)
                    peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'
                    

                    invoke (on peer that installed chaincode)
                    peer chaincode invoke -o orderer.example.com:7050  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem  -C $CHANNEL_NAME -n mycc -c '{"Args":["invoke","a","b","10"]}'


                    check the logs of chaincode (exit the container)
                    docker logs dev-peer0.org1.example.com-mycc-1.0

- Chaincode + dev network

    1)	chaincode for developers
        https://hyperledger-fabric.readthedocs.io/en/release-1.1/chaincode4ade.html

        •	every chaincode implements Chaincode Interface including methods e.g. Init/Invoke…
        •	another interface is ChaincodeStubInterface, for operating ledger’s state.
        •	prepare fabric dev-mode env

            install docker/docker compose/git/fabric binary including its samples

        •	understand the dev-mode
            all are pre-defined, 1 org, 1 peer, no anchor peer, an extra chaincode container for compliling.
            only update/restart chaincode container, no need to restart network, so it saves some time.

            pre-defined containers:
            ./fabric-samples/chaincode-docker-devmode/docker-compose-simple.yaml
            orderer, peer, cli, predefined chaincode container

        •	housekeeping
            docker rm -f $(docker ps -aq)
            docker network prune

        •	start the dev mode env with 4 terminals
            cd /u02/app/fabric-samples/chaincode-docker-devmode
            
            1)	terminal 1 - start network/code runtime/cli:
                docker-compose -f docker-compose-simple.yaml up

            2)	terminal 2 - build chaincode
                docker exec -it chaincode bash

                cd sacc
                go build

                (run the go program)
                CORE_PEER_ADDRESS=peer:7052 CORE_CHAINCODE_ID_NAME=mycc:0 ./sacc

                go/hyperledger/… are installed in this container so you can build chaincode here:

            3)	terminal 3 - install/instantiate/call the chaincode
                docker exec -it cli bash

                peer chaincode install -p chaincodedev/chaincode/sacc -n mycc -v 0
                peer chaincode instantiate -n mycc -v 0 -c '{"Args":["a","10"]}' -C myc

                peer chaincode invoke -n mycc -c '{"Args":["set", "a", "20"]}' -C myc
                peer chaincode query -n mycc -c '{"Args":["query","a"]}' -C myc

            4)	terminal 4 - update chaincode (no editor installed in terminal2/chaincode container)
                rm sacc.go && vi sacc.go
                copy/paste

                go to terminal 2 to kill the go process & rebuild & re-run it
                no need to reinstall and instantiate chaincode in terminal 3

            5)	develop chaincode locally
                get/install shim package:
                go get -u --tags nopkcs11 github.com/hyperledger/fabric/core/chaincode/shim

                build to see if there’s any error
                go build --tags nopkcs11      (or simply run go build)

                actually will use shim’s mock API to test its functions
                go test

        •	shim API
            go - https://godoc.org/github.com/hyperledger/fabric/core/chaincode/shim#ChaincodeStub 
            node - https://fabric-shim.github.io/ChaincodeStub.html

    2)	chaincode for operators
        https://hyperledger-fabric.readthedocs.io/en/release-1.1/chaincode4noah.html

        •	chaincode runs in an isolated container
        •	chaincode can be managed by SDK calling fabric’s API
        •	chaincode can also be managed by CLI
            the 4 commands are package/install/instantiate/upgrade
        •	multiple owners of chaincode
        •	you must/only install chaincode on each endorsing peer
        •	the CLI container
            docker run -it hyperledger/fabric-peer bash
            peer chaincode --help

- SDK + basic network

    1)	writting your first application (client app based on node SDK calling chaincode)
        https://hyperledger-fabric.readthedocs.io/en/release-1.1/write_first_app.html

        •	about the basic network that this SDK app uses
            1)	minium - only 1 org, 1 peer, couchDB, cli container
            2)	flexible - pre-generated artifacts, however you can generate them by the provided script

    •	housekeeping
        docker rm -f $(docker ps -aq)
        docker network prune

    •	start the basic network 
        cd /u02/app/fabric-samples/fabcar
        ./startFabric.sh

            1)	startFabric.sh calls ../basic-network/start.sh to create channel + use cli container to install  chaincode
            2)	you can modify it to use your own chaincode + use the cli conatiner directly
            check blockchain/fabcar/startMyFabric.sh

    •	install the sample SDK app
        node is v6.9.5, npm is v3.10.10

        there is a bug when run npm install - https://jira.hyperledger.org/browse/FABN-301
        fix it by: yum install gcc-c++

        npm install

    •	login admin - send a CSR (certificate signing requet) to CA service of the network
        node enrollAdmin.js
        enrollAdmin.js
        basic-network

    •	use admin to register a new user
        node registerUser.js

    •	query ledger
        node query.js
        node invoke.js

    •	update
        update below args in request before run it

- Network on multiple hosts

    1)	architecture
        •	based on byfn
        •	VM-1 for org1, IP=10.0.1.3
            orderer.example.com + peer0.org1.example.com + peer1.org1.example.com + cli
        •	VM-2 for org2, IP=10.0.0.10
            peer0.org2.example.com + peer1.org2.example.com + cli

    2)	verify byfn on VM-1/VM-2
    3)	prepare materials on VM-1 + copy to VM-2
        docker rm -f $(docker ps -aq)
        docker network prune

        ./byfn.sh -m generate

    4)	update hosts
        VM-1 
        10.0.0.10 peer0.org2.example.com
        10.0.0.10 peer1.org2.example.com

        (do not include VM-1 IP)

        VM-2
        10.0.1.3 orderer.example.com
        10.0.1.3 peer0.org1.example.com
        10.0.1.3 peer1.org1.example.com

        (do not include VM-2 IP)

    5)	modify docker-compose-cli.yaml
        VM-1
        •	make sure no ‘org2’ by search
        •	mount /etc/hosts
        rm -rf docker-compose-cli.yaml && vi docker-compose-cli.yaml

        VM-2
        •	make sure no ‘org1’ by search
        •	mount /etc/hosts
        rm -rf docker-compose-cli.yaml && vi docker-compose-cli.yaml

    6)	start network
        VM-1/VM-2
        docker-compose -f docker-compose-cli.yaml up -d

        (docker ps to check status)

    7)	create channel
        •	VM-1
        docker exec -it cli bash

        export CHANNEL_NAME=mychannel

        peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

        Notice: 
        if this’s not the first time you create channel, channel block is still there.

        orderer’s volume -> /var/lib/docker/volumes/net_peer0.org1.example.com/_data/ledgersData/chains/mychannel/blockfile_000000
        
        fetch existing block:
        peer channel fetch 0 $CHANNEL_NAME.block -c $CHANNEL_NAME -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

        •	refer to byfn to join peers/set anchor peers
        Notice: 
        you need to copy ./peer/mychannel.block from VM-1 to VM-2

    8)	install chaincode (refer to byfn)
        invoke from VM-1 cli
        query from VM-2 cli

    9)	test gossip offline query/data sync
        •	remove containers/network of VM-2
        •	invoke from VM-1
        •	restart containers from VM-2 + test data sync by query from VM-2
            verified, works!






        




 
















































            