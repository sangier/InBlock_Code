pragma solidity ^0.4.24;

import "./InBlock_F.sol";
import "./usingOraclize.sol";

contract InBlock is InBlock_F, usingOraclize{


//******************************************************* FUNCTIONS TO BE CALLED TO INITIALIZE THE CONTRACT *******************************************************

//Constructor

constructor() public{
	owner=msg.sender;  
	stopped=true; 
	askOracleCost=12000000000000000;
	OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475); //Testrpc
	//OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1); //Ropsten
	//OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);	//mainnnet
	price=100000000000000000000; //SECURITY UTILITY. EVERYONE HAS TO ASK FOR THE RIGHT PRICE FIRST. 
  }


//To Set the Initial Block  
 function activateInBlock(uint8 _base_certificate_mask, uint price) onlyOwner() public {
	base_certificate_mask=_base_certificate_mask;
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
	//require(msg.value==askPriceCost, "Price Error");
	 queryID1=oraclize_query("URL","json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
	 queryID2=oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
	 queryID3=oraclize_query("URL", "json(https://api.coinmarketcap.com/v1/ticker/ethereum/).0.price_usd");
	 }

function __callback(bytes32 _myid, string _result) {
     require (msg.sender == oraclize_cbAddress());
             if (_myid==queryID1) {
                           Log(_result);
        certificatePrice1 = parseInt(_result, 2);
              }
              if(_myid==queryID2) {
                           Log(_result);
        certificatePrice2 = parseInt(_result, 2);
		             }
			 if(_myid==queryID3) {
                           Log(_result);
        certificatePrice3 = parseInt(_result, 2);   
             }
}

function getcertificateCost()public{

if((certificatePrice1>certificatePrice2 && certificatePrice1>certificatePrice3) || (certificatePrice1<certificatePrice2 && certificatePrice1<certificatePrice3)){
	if((certificatePrice2>certificatePrice1 && certificatePrice2>certificatePrice3) || (certificatePrice2<certificatePrice1 && certificatePrice2<certificatePrice3)){
		price=certificatePrice3;
	}else price=certificatePrice2;
}else price=certificatePrice1;

price=(divide(dollarsPrice,price,5))*(10**13);
}

//******************************************************* KEY ROLLOVER FUNCTIONS *******************************************************


//Function to permit the change of the owner (the ones who recive the funds) 	
function transferInBlockControl(address new_owner)onlyOwner(){
	owner=new_owner;
	}

//Function to permit the transfer of the ownership of a specific block 
function transferCertificateControl(bytes4 ip,uint id, address new_owner) public {
		
		
		require(msg.sender==certificates[ip][id].o_addr, "You are not the owner of the block");
		certificates[ip][id].o_addr=new_owner;

}


//******************************************************* CONTRACT BALANCE FUNCTIONS *******************************************************


//fallback function to permit everyone to give ether to the contract
function pay () payable{}


}