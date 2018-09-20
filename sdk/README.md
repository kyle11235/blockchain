

# discover config
1. inspect the ca container to find the config file path

        docker inspect testtest1com_fabricca0.test1.com_1
        
        behind it is some volumes defiend in some docker-compose.yaml - ./crypto-config/peerOrganizations/org1.example.com/ca/:/etc/hyperledger/fabric-ca-server-config

2. login into ca container

        docker exec -it testtest1com_fabricca0.test1.com_1 bash

3. check the ca's name/affiliation in the config file
        
        cat /etc/hyperledger/fabric-ca-server-config/fabric-ca-server-config.yaml

4. ca config 

        name is empty - '', admin/adminpw
        
        affiliations:
           org1:
              - department1
              - department2
           org2:
              - department1 

# test
1. open tunnel to ca/orderer/peer && update port in codes

2. debug
    
        - check log from console/nodes/peer
        - docker logs testidplatformcom_peer1.idplatform.com_1 -f

