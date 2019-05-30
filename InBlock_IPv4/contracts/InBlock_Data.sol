pragma solidity ^0.4.24;

contract InBlock_Data{

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

uint public certificatePrice1;
uint public certificatePrice2;
uint public certificatePrice3;
uint public askOracleCost;
uint public price; 
uint public dollarsPrice;
int public ID;
uint public ID_Index;
int public ID_expired;
uint IDsReadLimit=5000;
uint IDsReadByOwnerLimit=2500;
uint OwnersReadLimit=2500;

//To store the price expressed in Wei (it is the common form). NB:  1 ether = 1000000000000000000 wei  
uint public prefixPrice;

//To store the initial_block
bytes4 public initial_block;
uint8 public base_certificate_mask;
	
	
//The owner address 
address public owner;

//For Start and Stop paradigm	
bool public stopped; 	


struct Info{
	bytes uri; 
	bytes hashFunction;
	bytes hash;
}


struct Certificate{
	bytes4 ip_address;
	address o_addr;
	uint id;
	bytes publicKeyRir;
	uint8 mask;
	uint date;
	uint validityT;
	Info info;
	bytes Roa;
}



//Necessary to performs division with float	
function divide(uint numerator, uint denominator, uint precision) internal pure returns(uint quotient) {

         // caution, check safe-to-multiply here
        uint _numerator  = numerator * 10 ** (precision+1);
        // with rounding of last digit
        uint _quotient =  ((_numerator / denominator) + 5) / 10;
        return ( _quotient);
  }



mapping(bytes4=>Certificate[]) public certificates;


}// END OF THE CONTRACT