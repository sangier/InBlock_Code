*********************************** Stefano Angieri @ Universidad Carlos III Madrid ***********************************

InBlock IPv6

To properly run the software:

In a cmd:
1.1:  Run a testrpc  (local private testnet)

In another cmd:
1.2:  Move into "Bridge\ethereum-bridge-master" folder 
1.3:  Run: node bridge -H localhost:8545 -a 1

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
3.3:  Run: x.getPrefixCost() 
3.4:  Run: x.prefix //then copy the result 

3.5:  Run: x.prefixRequest({from: wirte the address who will own the prefix, value: paste the result previously copied})
3.6:  Run: x.getIDsBlocks_address(address a,int start, int stop)  //It give us the IDs of the blocks owned by the user having the specific address // NB. New start and stop paradigm to overcome computational limitation. Instead of asking for a search on the whole database we have to split the search in chunks. 
3.7:  Run: x.getItem(id discovered before);//we can access to those block with the given IDs discovered before

//NB the prefixRequest function will properly work until the total number of available blocks has been assigned. After that this function only work if the x.getRecovered() function does not give an empty result. See 6 for expired recovering mode 


To perform and verify a sequent_allocation:
4.1:  Run: x.askOracleCost() //then copy the result
4.2:  Run: x.getOracleCurrencyConversion({value: the copied value})
4.3:  Run: x.getPrefixCost() 
4.4:  Run: x.prefix() //then copy the result 

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
