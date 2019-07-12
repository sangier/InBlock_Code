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

First the manager has to insert the RIRs public key. Once InBlock is activated he will not be able to  insert or change the keys.

1.11: insertApnicPk("key")
1.12: insertLacnicPk("key")
1.13: insertRipePk("key")
1.14: insertAfrinicPk("key")
1.15: insertArinPk("key")

To initialize the contract Run:

 
2.1:  Run: x.activateInBlock(base_mask_bits number,price) //where price has to be expressed as follow: 1800.00 --> 180000 

To insert a Certificate 
3.1:  Run: x.askOracleCost() //then copy the result
3.2:  Run: x.getOracleCurrencyConversion({value: the copied value})
3.3:  Run: x.getCertificatePrice() 
3.4:  Run: x.price() //then copy the result 


NB the user has to sign his ethereum address with his private key from the authority key-pair. 

3.5:  Run: x.registerPrefix("hexip","uri","SignedHash","hashFunction","ROAs",{value: paste the result previously copied})

To read Certificates informations


To Read prefix Registration IDs	// NB. start-stop <5000  due to gas limit reason. As example if you want to take 8000 records info just call twice the function with 0,4999 and 5000,8000. 
4.1: Run x.getPrefixRegistrationIDs(bytes4 ip, uint start, uint stop)

Once we get the ID of a certificate

To get prefix registration uri to rpki repository and signed hash
4.2 Run: x.getRegistrationUriRpkiSigHash(ip,id)

To get registered prefix info 
4.3 Run: x.getRegisteredPrefixInfo(ip,id)

To get RIRs public Keys 
4.4 Run: x."RIRNAME"publicKey()

To Modify a prefix ROAs: 
4.5 Run: updatePrefixROA(ip,id,ROAs)

To Modify a prefix URI: 
4.6 Run:  updatePrefixURI(ip,id,uri)

To Renew a registration 
4.7 Run: renewRegistration(ip, id,{value:fee to be paid})

To delegate a prefix: 
4.8 Run: delegatePrefix(ip,id,delegated_address)

To update a delegated prefix roa 
4.9 Run: updatePrefixDelRoa(ip,id,roas)

To update a delegated prefix policy uri
4.10 Run: updatePrefixDelUri(ip,id,uri)

To remove a prefix delegation
4.11 Run: removeDelegation(ip,id)
