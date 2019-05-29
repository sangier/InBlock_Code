*********************************** Stefano Angieri @ Universidad Carlos III Madrid ***********************************

InBlock IPv4 

To properly run the software:

In a cmd:
1.1:  Run a testrpc  (local private testnet)

In another cmd:
1.2:  Move into "Bridge\ethereum-bridge-master" folder 
1.3:  Run: node bridge -H localhost:8545 -a 1

In another cmd: 
1.4:  Move into  "InBlock_v1\contracts" folder 
1.5:  Run: truffle compile
1.6:  Run: truffle migrate 
1.7:  Run: truffle console

1.8:  Run: InBlock.deployed()
1.9:  Copy the given address
1.10: Run x=InBlock.at("paste the address")  //you can type x or whatever you want

You can now start to play with the contract 

To initialize the contract Run: 
2.1:  Run: x.activateInBlock(base_mask_bits number,price) //where price has to be expressed as follow: 1800.00 --> 180000 

To insert a Certificate 
3.1:  Run: x.askOracleCost() //then copy the result
3.2:  Run: x.getOracleCurrencyConversion({value: the copied value})
3.3:  Run: x.getCertificatePrice() 
3.4:  Run: x.price() //then copy the result 

3.5:  Run: x.insertCertificate("hexip","uri","hash","hashFunction",{value: paste the result previously copied})

To read Certificates informations

To read Certificates Owners associated to a prefix //NB. start-stop <2500  due to gas limit reason 
4.1: Run x.readCertificateOwners(ip,start,stop)

To read Certificates IDs associated to an Owner //NB. start-stop <2500  due to gas limit reason
4.2: Run x.readCertificateIDsByOwner(ip,address,start,stop)

To Read Certificates IDs	// NB. start-stop <5000  due to gas limit reason
4.3: Run x.readCertificateIDs(bytes4 ip, uint start, uint stop)

Once we get the ID of a certificate
4.4 Run: x.getCertificates(ip,id)


To Modify a certificate info: 
4.5 Run: updateCertificateROA_Info(ip,id,ROAs,uris,hash, hashFunction)
