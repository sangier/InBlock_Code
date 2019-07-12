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

modifier notActive(){
	require(active==false);
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


modifier onlyCertOwner(bytes4 ip, uint id){

require(msg.sender==certificates[ip][id].o_addr);
_;
}


modifier onlyDelOwner(bytes4 ip, uint id){
require(msg.sender==certificates[ip][id].del.oD_addr);
_;

}


//******************************************************* DATA STRUCTURE DEFINITION *******************************************************

uint public certificatePrice1;
uint public certificatePrice2;
uint public certificatePrice3;
uint public askOracleCost;
//To store the price expressed in Wei (it is the common form). NB:  1 ether = 1000000000000000000 wei  
uint public price; 
uint public dollarsPrice;
uint IDsReadLimit=5000;

bytes public ArinPublicKey;
bytes public RipePublicKey;
bytes public LacnicPublicKey;
bytes public AfrinicPublicKey;
bytes public ApnicPublicKey;


uint8 public base_certificate_mask;
uint8 public delegation_mask;
	
//The owner address 
address public owner;

//For Start and Stop paradigm	
bool public stopped; 	
bool public active;


struct delegation{

bytes uri;
bytes Roa;
address oD_addr;

}

struct Info{
	bytes uri; 
	bytes hashFunction;
	bytes SignedHash;
}


struct Certificate{
	bytes4 ip_address;
	address o_addr;
    delegation del;
	bytes UriToRpki;
	uint id;
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