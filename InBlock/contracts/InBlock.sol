pragma solidity ^0.4.24;

import "./InBlock_F.sol";
import "./InBlock_F_del.sol";
import "./usingOraclize.sol";

contract InBlock is InBlock_F, InBlock_F_del, usingOraclize{


//******************************************************* FUNCTIONS TO BE CALLED TO INITIALIZE THE CONTRACT *******************************************************

//Constructor

constructor() public{
	owner=msg.sender;  
	seed=0;
	ID=0;
	stopped=true; 
	askOracleCost=43744080000000000;
	//OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475); //Testrpc
	//OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1); //Ropsten
	OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);	//mainnnet
	prefixPrice=100000000000000000000; //SECURITY UTILITY. EVERYONE HAS TO ASK FOR THE RIGHT PRICE FIRST. 
  }


//To Set the Initial Block  
 function activateInBlock(bytes16 ip,uint8 _base_prefix_mask, uint8 _allocation_prefix_mask, uint price) onlyOwner() public {
	base_prefix_mask=_base_prefix_mask;
	allocation_prefix_mask=_allocation_prefix_mask;
	max_del=48;
	max_allocable_blocks=(2**uint(_allocation_prefix_mask-_base_prefix_mask));
	ID=1;
	blocks[0].ip_address=ip;
	blocks[0].o_addr=msg.sender;
	blocks[0].mask=base_prefix_mask;
	initial_block=ip;
	ID_Index=0;
	dollarsPrice=price;
	stopped=false;

}
	
//******************************************************* ORACLE FUNCTIONS *******************************************************

bytes32 queryID1;
bytes32 queryID2;
bytes32 queryID3;
event Log(string text);

function getOracleCurrencyConversion() public payable{
	 require(msg.value==askPriceCost, "Price Error");
	 queryID1=oraclize_query("URL","json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
	 queryID2=oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
	 queryID3=oraclize_query("URL", "json(https://api.coinmarketcap.com/v1/ticker/ethereum/).0.price_usd");
	 }

function __callback(bytes32 _myid, string _result) {
     require (msg.sender == oraclize_cbAddress());
             if (_myid==queryID1) {
                           Log(_result);
        prefixPrice1 = parseInt(_result, 2);
              }
              if(_myid==queryID2) {
                           Log(_result);
        prefixPrice2 = parseInt(_result, 2);
		             }
			 if(_myid==queryID3) {
                           Log(_result);
        prefixPrice3 = parseInt(_result, 2);   
             }
}

function getPrefixCost()public{

if((prefixPrice1>prefixPrice2 && prefixPrice1>prefixPrice3) || (prefixPrice1<prefixPrice2 && prefixPrice1<prefixPrice3)){
	if((prefixPrice2>prefixPrice1 && prefixPrice2>prefixPrice3) || (prefixPrice2<prefixPrice1 && prefixPrice2<prefixPrice3)){
		price=prefixPrice3;
	}else price=prefixPrice2;
}else price=prefixPrice1;

prefixPrice=(divide(dollarsPrice,price,5))*(10**13);
}

//******************************************************* KEY ROLLOVER FUNCTIONS *******************************************************


//Function to permit the change of the owner (the ones who recive the funds) 	
function transferInBlockControl(address new_owner)onlyOwner(){
	owner=new_owner;
	}

//Function to permit the transfer of the ownership of a specific block 
function transferAllocatedPrefixControl(bytes16 ip,address new_owner) public {
		
		int id= int(reverseSparse(ip));
		require(blocks[id].ip_address!="");
		require(msg.sender==blocks[id].o_addr, "You are not the owner of the block");
		blocks[id].o_addr=new_owner;

}

function transferDelegatedPrefixControl(bytes16 ip, bytes16 ip2, uint8 mask, address new_owner) public {
		
		int id= int(reverseSparse(ip));
		require(!isPrefixInUse(id));
		int id2= del_find(ip, ip2, mask);
		require(id2!=-1 && id2!=-2);
		require(msg.sender==blocks[id].del_blocks[id2].o_addr, "You are not the owner of the block");
		blocks[id].del_blocks[id2].o_addr=new_owner;

}

//******************************************************* CONTRACT BALANCE FUNCTIONS *******************************************************


//fallback function to permit everyone to give ether to the contract
function pay () payable{}


}