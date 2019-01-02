pragma solidity ^0.4.24;

import "./InBlock_F.sol";
import "./InBlock_F_del.sol";
import "./usingOraclize.sol";

contract InBlock is InBlock_F, InBlock_F_del, usingOraclize{


//test functions 
function expire(int id)public{

blocks[id].date=blocks[id].date-400* 1 days;
}

function setID(int id)public{
ID=id;
}
	
function test(int i)public returns (int) {
return array_index[i].ind;
}

function stub()public{

for(int i=0; i<15; i++){
sparse_allocation();
}
}

function stub2()public{

for(int i=0; i<25; i++){
sparse_allocation();
}
}


function setID_index(int i)public { 

ID_Index=i;
}

//******************************************************* FUNCTIONS TO BE CALLED TO INITIALIZE THE CONTRACT *******************************************************

//Constructor

constructor() public{
	owner=msg.sender;  
	seed=0;
	ID=0;
	stopped=true;
	askPriceCost=4027700000000000;
	OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
	blockprice=5000000000000000000; //SECURITY UTILITY. EVERYONE HAS TO ASK FOR THE RIGHT PRICE FIRST. 
  }

//To Set the Initial Block  
 function InitInBlock(bytes16 ip,uint8 _base_prefix_mask, uint8 _allocation_prefix_mask) onlyOwner() public {
	base_prefix_mask=_base_prefix_mask;
	allocation_prefix_mask=_allocation_prefix_mask;
	max_del=48;
	max_allocable_blocks=(2**uint(_allocation_prefix_mask-base_prefix_mask));
	ID=1;
	blocks[0].ip_address=ip;
	blocks[0].o_addr=msg.sender;
	blocks[0].mask=base_prefix_mask;
	initial_block=ip;
	ID_Index=0;
	stopped=false;
}
	

//EXAMPLE: IF WE WANT TO SET A PRICE OF 1800.00 $ WE HAVE TO CALL THIS FUNCTION IN THAT WAY setDollarsPrice(180000) 
function setDollarsPrice(uint a) onlyOwner(){
	dollars_price=a;
}
	
//******************************************************* ORACLE FUNCTIONS *******************************************************

event Log(string text);

function askPrice() public payable{
	require(msg.value==askPriceCost, "Price Error");
	 oraclize_query("URL","json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
	 }
	 
function __callback(bytes32 _myid, string _result) {
		require (msg.sender == oraclize_cbAddress());
		Log(_result);
        price = parseInt(_result, 2);
		blockprice=(divide(dollars_price,price,5))*(10**13);
	}

//******************************************************* KEY ROLLOVER FUNCTIONS *******************************************************


//Function to permit the change of the owner (the ones who recive the funds) 	
function changeOwner(address new_owner)onlyOwner(){
	owner=new_owner;
	}

//Function to permit the transfer of the ownership of a specific block 
function transferOwnership(bytes16 ip,address new_owner) public {
		
		int id= find(ip,allocation_prefix_mask);
		require(id!=-1);
		require(msg.sender==blocks[id].o_addr, "You are not the owner of the block");
		blocks[id].o_addr=new_owner;

}
		  
//******************************************************* CONTRACT BALANCE FUNCTIONS *******************************************************


//fallback function to permit everyone to give ether to the contract
function pay () payable{}


}