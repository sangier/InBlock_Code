pragma solidity ^0.4.24;

import "./Utility.sol";

contract InBlock_Data is Utility{

//******************************************************* MODIFIERS AND RELATED FUNCTION *******************************************************


//FOR START AND STOP PARADIGM

function circuitBreaker() onlyOwner() public{
	stopped=false;
} 

modifier notStopped(){
	if(stopped)throw;
	_;
}

function toggleCircuit() onlyOwner() public{
	stopped=!stopped;
}



modifier onlyOwner(){
   require (msg.sender == owner);
        _;
}


/*function setSeed(uint a)public {
seed=a;
}*/


//******************************************************* DATA STRUCTURE DEFINITION *******************************************************

uint public prefixPrice1;
uint public prefixPrice2;
uint public prefixPrice3;
uint public oraclesValidity;
uint public securityPrice;
//uint public askOracleCost;
uint public price; 
uint public dollarsPrice;
int public ID;
int public ID_Index;
int public ID_expired;

//To store the price expressed in Wei (it is the common form). NB:  1 ether = 1000000000000000000 wei  

struct userPrefixPrice{
uint prefixPrice;
uint validity;
}


mapping(address=>userPrefixPrice) userPrefixPrices;

//To store the initial_block
bytes16 public initial_block;
uint8 public base_prefix_mask;
	
	
//The owner address 
address public owner;

//For Start and Stop paradigm	
bool public stopped; 	
	
//To manage allocation and delegation
uint8 public max_del;
uint8 public allocation_prefix_mask;
uint public seed;
uint public max_allocable_blocks;

struct index{
int ind;
}

struct dIndex{
int counter;
mapping(int=>int) del_ID_List;
}

struct Info{
	bytes uri; 
	bytes hashFunction;
	bytes hash;
}

struct Block{
	bytes16 ip_address;
	address o_addr;
	uint8 mask;
	uint date;
	Info info;
	bytes Roa;
	mapping(int=>del_Block) del_blocks;
	mapping(int=>index) del_array_index; 
	dIndex dindex;
	int del_ID_Index;
	int ID_delegated;
}

struct del_Block{
	bytes16 ip_address;
	address o_addr;
	uint8 mask;
	int parent;
	int left;
	int right;
	Info info;
	bytes Roa;
	
}


mapping(int =>index) array_index;
mapping(int =>index) expired_array_index;

mapping(int=>Block) blocks;


//******************************************************** COMMON FUNCTION ***********************************************************************
	  
	 function reverseSparse(bytes16 input) public view returns (uint num) {
        uint256 n = 0;
        uint256 n0=0;
		uint256 n1=0;
		uint256 n2=0;
		uint256 n3=0;
		uint256 n4=0;
		uint256 n5=0;
		uint256 n6=0;
		uint256 w=0;
		for(uint8 j=0; j<base_prefix_mask+1;j++){
			if(getBit(input,128-j)){
				input=clearBit(input, 128-j);
			}
		
		}
		
		for (uint8 i = 0; i < allocation_prefix_mask-base_prefix_mask; i++) {
            if (getBit(input,128-(base_prefix_mask+1+i))){
				if(0<=i && i<=3){
				n=n+2**w;
				}
				if(4<=i && i<=7){
				n0= n0+ 2**w;
				}
				if(8<=i && i<=11){
				n1= n1+2**w;
				}
				if(12<=i && i<=15){
				n2= n2+2**w;
				}
				if(16<=i && i<=19){
				n3= n3+2**w;
				}
				if(20<=i && i<=23){
				n4= n4+2**w;
				}
				if(24<=i && i<=27){
				n5= n5+2**w;
				}
				if(28<=i && i<=31){
				n6= n6+2**w;
				}
				
				
            }
			w=w+1;
			if(w==4){
			w=0;
			}
        }
		
			n=n+16*n0;
			n=n+16*16*n1; 
			n=n+16*16*16*n2;
			n=n+16*16*16*16*n3;
			n=n+16*16*16*16*16*n4;
			n=n+16*16*16*16*16*16*n5;
			n=n+16*16*16*16*16*16*16*n6;
        return (n+1);
    } 
	  

function sparse(uint id) public view returns(bytes16){

	bytes16 app = initial_block;
	if(id%2 !=0) app=setBit(app,128-(base_prefix_mask+1));  
	for(uint8 j=1; j<(allocation_prefix_mask-base_prefix_mask); j++){
		if((id/(2**(uint(j))))%2!=0) app=setBit(app,128- (base_prefix_mask+1+j));
		}
	return app;
}


  function isAllocatedPrefixExpired(int id) view public returns (bool){
	
	if(now >= (blocks[id].date + 365* 1 days) && blocks[id].date!=0 ){
		return true;
		}else return false; 
	}

	/*function isPrefixInUseIP(bytes16 ip) view public returns(bool){
	int id=int(reverseSparse(ip));
		if(!isAllocatedPrefixExpired(id)){
			return true;
		}
		else if(blocks[id].ip_address==""){
			return false; 
			}
		return true;
	}*/
	
	function isPrefixInUse(int id) view public returns(bool){
		if(!isAllocatedPrefixExpired(id)){
			return true;
		}
		else if(blocks[id].ip_address==""){
			return false; 
			}
		return true;
	}

  /*function expire_id(int id) public returns (bool){
	
	if(blocks[id].date!=0 ){
	    blocks[id].date=blocks[id].date - 365* 1 days;
		return true;
		}else return false; 
	}*/


}// END OF THE CONTRACT