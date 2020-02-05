*********************************** Stefano Angieri @ Universidad Carlos III Madrid ***********************************

InBlock IPv6

To properly run the software:

In a cmd:
1.1: (local private testnet)  Run :ganache-cli -l 2000000000000000000  --allowUnlimitedContractSize --db C:\Users\User\Desktop\GanacheDir\Blocks --account_keys_path C:\Users\User\Desktop\GanacheDir\Accounts\Accounts.txt --defaultBalanceEther 900000000000000000000  -i 100 
      ganache-cli -l 2000000000000000000  --allowUnlimitedContractSize --db C:\Users\User\Desktop\GanacheDir\Blocks --account_keys_path C:\Users\User\Desktop\GanacheDir\Accounts\Accounts.json --defaultBalanceEther 900000000000000000000 --mnemonic "surprise shine chalk surprise theory stem wrestle step soup attitude trend valid" -i 100


For Linux:
First Instance: ganache-cli -l 2000000000000000000  --allowUnlimitedContractSize --db /home/sangieri/GanacheDir/Blocks --account_keys_path /home/sangieri/GanacheDir/Accounts/Accounts.txt --defaultBalanceEther 900000000000000000000 -i 120
Resume: ganache-cli -l 2000000000000000000  --allowUnlimitedContractSize --db /home/sangieri/GanacheDir/Blocks --account_keys_path /home/sangieri/GanacheDir/Accounts/Accounts.txt --defaultBalanceEther 900000000000000000000 -i 120 --mnemonic "process lend faint height crumble rotate humble mesh tape spike pluck pride"

In another cmd:
1.2:  Move into "Bridge\ethereum-bridge-master" folder 
1.3:  Run: ethereum-bridge -H localhost:8545 -a 1

In InBlock.sol 
Decomment the right OAR line according to the used network 
      OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475); //Testrpc
	//OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1); //Ropsten
	//OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);	//mainnnet 

In another cmd: 
1.4:  Move into  "InBlock\contracts" folder 
1.5:  Run: truffle compile
1.6:  Run: truffle migrate 
1.7:  Run: truffle console

1.8:  Run: InBlock.deployed()
1.9:  Copy the given address
1.10: Run x=InBlock.at("paste the address")  //you can type x or whatever you want

You can now start to play with the contract 

To initialize the contract Run: 
2.1:  Run: x.activateInBlock("base complete prefix expressed in HEX",number of base_mask_bits,number of allocabale_mask_bits,price) //where price has to be expressed as follow: 1800.00 --> 180000 example: x.activateInBlock("0x2001d000000000000000000000000000",20,32,300000)
To perform and verify a sparse_allocation: 
3.1:  Run: x.askOracleCost() //then copy the result
3.2:  Run: x.getOracleCurrencyConversion({value: the copied value})
3.3:  Run: x.computePrefixCost() 
3.4:  Run: x.getPrefixCost() //then copy the result 

3.5:  Run: x.prefixRequest({from: wirte the address who will own the prefix, value: paste the result previously copied})
3.6:  Run: x.getIDsBlocks_address(address a,int start, int stop)  //It give us the IDs of the blocks owned by the user having the specific address // NB. New start and stop paradigm to overcome computational limitation. Instead of asking for a search on the whole database we have to split the search in chunks. 
3.7:  Run: x.getItem(id discovered before);//we can access to those block with the given IDs discovered before

//NB the prefixRequest function will properly work until the total number of available blocks has been assigned. After that this function only work if the x.getRecovered() function does not give an empty result. See 6 for expired recovering mode 


To perform and verify a sequent_allocation:
4.1:  Run: x.askOracleCost() //then copy the result
4.2:  Run: x.getOracleCurrencyConversion({value: the copied value})
4.3:  Run: x.computePrefixCost() 
4.4:  Run: x.getPrefiCost() //then copy the result 

4.5:  Run: x.sequentialAllocationPrefixRequest("ip_address of already owned prefix",{from: wirte the address who will own the prefix, value: paste the result previously copied})  
4.6:  Run: x.getIDsBlocks_address(address a,int start, int stop)  //NB. New start and stop paradigm to overcome computational limitation. Instead of asking for a search on the whole database we have to split the search in chunks. 
4.7:  Run: x.getItem(id discovered before); //we can access to those block with the given IDs discovered before 



Delgation: 

Precodition. At least one Block has to be requested. 

5.1 Run: delegate_block(parent_ip, del_ip, mask, delegated_address)
5.2.1 Run: x.del_find(parent_ip, del_ip, mask)
5.2.2 Run: x.getIDs_del_Blocks(parent_ip, int start, int stop) // To get all the valid del_block ID delegated from the parent Block 
5.3.1 Run: x.get_del_Block_id(int id, int id2) // NB you can find id simply typing x.reverseSparse(parent_ip)
5.3.2 Run: x.get_del_Block_ip(ip_parent, del_ip, mask)

To revoke delegation: 
5.4: revokeDelegatedPrefix(parent_ip, del_ip,mask)


Expired Block Recovery:

6.1: Run: x.getIDsBlocks_expired(start, stop)
6.2: Run: x.recoverExpiredBlock(id) // this operation has to be done block for block using the ID. 
6.3: Run: x.getRecovered() 


INFO and ROA functions: 

For a Block
7.1: Run: x.setPolicyURI(bytes16 ip, bytes uri, bytes hashFunction, bytes hash) // example : x.setInfoBlock("0x2001d000000000000000000000000000", "www.inblock.com","sha252","0xasdw123123jasdag1")
7.2: Run: x.getItem(id) // Find the Id with x.find(ip,allocation_prefix_mask);
7.2: Run: x.setRoA(bytes16 ip, bytes ASes)  //example: x.setRoaBlock("0x2001d000000000000000000000000000", "0,13, all ases number separeted by , 10") 
7.3: Run: x.getRoA(bytes16 ip)

For a del_Block
7.4: Run: x.setDelegatedPrefixPolicyURI(bytes16 ip_parent, bytes16 ip, uint8 mask, bytes uri, bytes hashFunction, bytes hash)
7.5: Run: x.getDelegatedPrefixPolicyURI(bytes16 ip_parent, bytes16 ip, uint8 mask)
7.6: Run: x.setDelegatedPrefixRoA(bytes16 ip_parent, bytes16 ip, uint8 mask, bytes ASes)
7.7: Run: x.getDelegatedPrefixRoA(bytes16 ip_parent, bytes16 ip, uint8 mask)







Hola, 

Os escribo un pseudo codigo de lo que tiene que hacer una tercera parte para construir su tabla de ROAs a travers de InBlock. 

CALL: getIDsAssignedBlocks(int start, int stop)     (Devuelve un listado de IDs de los prefixos validos,  con stop - start<=500)
 For Each ID:
CALL :getItem(int ID)     (Devuelve todo el objecto prefixo con Roa y info sobre la roa)
CALL: getIDsDelBlocks(int ID) returns(uint[]result)  (Devuelve un listado de IDs del los prefixos delegados, validos)
For Each delegated ID
getDelBlockID_Roa(ID,delegatedID)  (Devuelve todo el objecto prefixo_delegado con Roa y info sobre la roa)

Todas las interacciones con el contrato son CALL asì que no hay costes a pagar por la computacion. 

Quedan por hacer: 
Nueva analysis de los costes de las funciones de delegaciones.  
Nueva analysis de los tiempos de inclusion el blockchain de las funciones de delegaciones.   Hace falta hacerla? Los resultados van a ser muy parecidos a los de las otras funciones. 
Analysis de tiempo de construcción de la tabla de Roa.
Analysis de tiempo de construcción de la tabla de Roa al variar de la longitud del prefixo base.  
Saludos 
