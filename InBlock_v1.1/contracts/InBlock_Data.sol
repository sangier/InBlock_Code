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


//************************************************************ Users Privileges ********************************************************************************

modifier onlyOwner(){
   require (msg.sender == owner);
        _;
}



struct User{
int privilege;
bool holding;
}

mapping(address=>User) Users;

mapping(address=>User) SuperUsers;


function addSuperUserAccount(address addr) public onlyOwner{
       SuperUsers[addr].privilege=2;
	   SuperUsers[addr].holding=false;
}

function addUserAccount(address addr) public onlySuperUsers(msg.sender){
        require(SuperUsers[msg.sender].privilege==2);
		Users[addr].privilege=3;
		Users[addr].holding=false;
		}

function deleteSuperUserAccount(address addr) public onlyOwner(){
	require(!SuperUsers[addr].holding);
	SuperUsers[addr].privilege=0;
}

function deleteUserAccount(address addr) public onlySuperUsers(msg.sender){
	require(!Users[addr].holding);
	Users[addr].privilege=0;
}

function changeUserAccount(address addr) public {

	require(Users[msg.sender].privilege==3);
		Users[msg.sender].privilege=0;
		Users[addr].privilege=3;
	if(Users[msg.sender].holding==true){
		Users[msg.sender].holding==false;
		Users[addr].holding=true;
	}
	
}

function changeSuperUserAccount(address addr) public {

	require(SuperUsers[msg.sender].privilege==2);
		SuperUsers[msg.sender].privilege=0;
		SuperUsers[addr].privilege=2;
	if(SuperUsers[msg.sender].holding==true){
		SuperUsers[msg.sender].holding==false;
		SuperUsers[addr].holding=true;
	}
	
}


function getUserPrivilege(address addr) public view returns (int) {
    return Users[addr].privilege;
}

function getSuperUserPrivilege(address addr) public view returns(int){
	return SuperUsers[addr].privilege;
}

modifier onlySuperUsers(address addr){
	require(SuperUsers[addr].privilege==2 || msg.sender==owner);
	_;
}


modifier onlyUsersOrSuper(address addr){
	require(Users[addr].privilege==3 || SuperUsers[addr].privilege==2 || msg.sender==owner);
	_;
}


//******************************************************* DATA STRUCTURE DEFINITION *******************************************************


uint public askPriceCost;
uint public price; 
uint public dollars_price;
int public ID;
int public ID_Index;
int public ID_expired;

//To store the price expressed in Wei (it is the common form). NB:  1 ether = 1000000000000000000 wei  
	uint public blockprice;

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
	int parent;
	int left;
	int right;
	Info info;
	bytes Roa;
	mapping(int=>del_Block) del_blocks;
	mapping(int=>index) del_array_index;
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
function find(bytes16 ip_address, uint8 _mask) public view returns (int) {
		int id = 0;
		int i=0;
		bool ok=false;
       
        while (i<(allocation_prefix_mask-base_prefix_mask)+1) {
            if (ip_address == blocks[id].ip_address && _mask==blocks[id].mask) {
				ok=true;
				return id;
            }
       
           if(!getBit(ip_address,(128-(base_prefix_mask+uint8(i)+1)))){
			    id = blocks[id].left;
            } else {
                id = blocks[id].right;
            }
        i=i+1;
		}
		if(ok)return id; 
		else return -1;
    }

	  
  function is_expired_id(int id) view public returns (bool){
	
	if(now >= (blocks[id].date + 365* 1 days) && blocks[id].date!=0 ){
		return true;
		}else return false; 
}

}// END OF THE CONTRACT