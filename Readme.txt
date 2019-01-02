******************************************************* Stefano Angieri : Universidad Carlos III Madrid ***************************************************************************************************


InBlock Version 1.1
Update: 

a. New data structure to manage Blocks and del_blocks: a modified version of Binary Trie has been implemented. 
a.a Performance Improvement. 
a.b Computational issues solved. 
b. New organization of contracts.               
c. New pattern to recover expired Blocks. 


NB: Deployment gas cost:
To deploy InBlock_v1.1 15 transaction are needed. All are smaller than the current Mainnet gas Limit: 8000029. We will not have any problem to deploy it on the Mainnet.  


Bridge Deployment:
Gas usage: 3127455
Gas usage: 29147
Gas usage: 21000
Gas usage: 140295
Gas usage: 28395
Gas usage: 43417
Gas usage: 1497375
Gas usage: 692109

InBlock_v1.1 Deployment
Gas usage: 224195
Gas usage: 41908
Gas usage: 502088
Gas usage: 68794
Gas usage: 2522486
Gas usage: 3185206
Gas usage: 6418287



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
2.1:  Run: x.InitInBlock("base complete prefix expressed in HEX",number of base_mask_bits,number of allocabale_mask_bits) //example: x.InitInBlock("0x2001d000000000000000000000000000",20,32)
2.2:  Run: x.setDollarsPrice(price) where price has to be expressed as follow: 1800.00 --> 180000 //example: x.setDollarsPrice(180000) 

To perform and verify a sparse_allocation: 
3.1:  Run: x.askPriceCost() //then copy the result
3.2:  Run: x.askPrice({value: the copied value})
3.3:  Run: x.blockprice() //the copy the result 

3.4:  Run: x.sparse_allocation({from: wirte the address who will own the prefix, value: paste the result previously copied})
3.5:  Run: x.getIDsBlocks_address(address a,int start, int stop)  //It give us the IDs of the blocks owned by the user having the specific address // NB. New start and stop paradigm to overcome computational limitation. Instead of asking for a search on the whole database we have to split the search in chunks. 
3.6:  Run: x.getItem(id discovered before);//we can access to those block with the given IDs discovered before

//NB the sparse_allocation function will properly work until the total number of available blocks has been assigned. After that this function only work if the x.getRecovered() function does not give an empty result. See 6 for expired recovering mode 


To perform and verify a sequent_allocation:

4.1:  Run: x.askPriceCost() //then copy the result
4.2:  Run: x.askPrice({value: the copied value})
4.3:  Run: x.blockprice() //the copy the result 

4.4:  Run: x.sequent_allocation_allocation("ip_address of already owned prefix",{from: wirte the address who will own the prefix, value: paste the result previously copied})  
4.5:  Run: x.getIDsBlocks_address(address a,int start, int stop)  //NB. New start and stop paradigm to overcome computational limitation. Instead of asking for a search on the whole database we have to split the search in chunks. 
4.6:  Run: x.getItem(id discovered before); //we can access to those block with the given IDs discovered before 



Delgation: 

Precodition. At least one Block has to be requested. 

5.1 Run: delegate_block(parent_ip, del_ip, mask, delegated_address)
5.2.1 Run: x.del_find(parent_ip, del_ip, mask)
5.2.2 Run: x.getIDs_del_Blocks(parent_ip, int start, int stop) // To get all the valid del_block ID delegated from the parent Block 
5.3.1 Run: x.get_del_Block_id(int id, int id2) // NB you can find id simply typing x.find(parent_ip,allocation_prefix_mask)
5.3.2 Run: x.get_del_Block_ip(ip_parent, del_ip, mask)

To revoke delegation: 
5.4: revoke_delegation(parent_ip, del_ip,mask)


Expired Block Recovery:

6.1: Run: x.getIDsBlocks_expired(start, stop)
6.2: Run: x.recover_expired_block(id) // this operation has to be done block for block using the ID. 
6.3: Run: x.getRecovered() 


INFO and ROA functions: 

For a Block
7.1: Run: x.setInfoBlock(bytes16 ip, bytes uri, bytes hashFunction, bytes hash) // example : x.setInfoBlock("0x2001d000000000000000000000000000", "www.inblock.com","sha252","0xasdw123123jasdag1")
7.2: Run: x.getItem(id) // Find the Id with x.find(ip,allocation_prefix_mask);
7.2: Run: x.setRoaBlock(bytes16 ip, bytes ASes)  //example: x.setRoaBlock("0x2001d000000000000000000000000000", "0,13, all ases number separeted by , 10") 
7.3: Run: x.getBlockASes(bytes16 ip)

For a del_Block
7.4: Run: x.setInfo_del_Block(bytes16 ip_parent, bytes16 ip, uint8 mask, bytes uri, bytes hashFunction, bytes hash)
7.5: Run: x.get_del_Block_ip(bytes16 ip_parent, bytes16 ip, uint8 mask)
7.6: Run: x.setRoa_del_Block(bytes16 ip_parent, bytes16 ip, uint8 mask, bytes ASes)
7.7: Run: x.get_del_BlockASes(bytes16 ip_parent, bytes16 ip, uint8 mask)


The other operation are quiete similar. Just type inputs in the right format. 