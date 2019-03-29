pragma solidity ^0.4.24;

contract Utility{




//*********************************************************** UTILITY FUNCTIONS **********************************************************************************


//The following function are needed for bits operation	
    
function shiftLeft(bytes16 a, uint128 n) internal returns (bytes16) {
        var shifted = uint128(a) * 2 ** n;
        return bytes16(shifted);
}
    
function getFirstN(bytes16 a, uint128 n) internal returns (bytes16) {
        var nOnes = bytes16(2 ** n-1); 
        var mask = shiftLeft(nOnes, 128 - n); // Total 128 bits
        return a & mask;
} 
    
   	
function allOnes() internal returns (bytes16) {
        return bytes16(-1); // 0 - 1, since data type is unsigned, this results in all 1s.
    }
	
    function negate(bytes16 a) internal returns (bytes16) {
        return a ^ allOnes();
    }
    
    // Set bit value at position
    function setBit(bytes16 a, uint8 n) internal returns (bytes16) {
        return a | shiftLeft(0x01, n);
    }
    
    // Set the bit into state "false"
    function clearBit(bytes16 a, uint8 n) internal returns (bytes16) {
        bytes16 mask = negate(shiftLeft(0x01, n));
        return a & mask;
    }	
	
	  // Get bit value at position
    function getBit(bytes16 a, uint8 n) internal returns (bool) {
        return a & shiftLeft(0x01, n) != 0;
    }

//Necessary to performs division with float	
function divide(uint numerator, uint denominator, uint precision) internal pure returns(uint quotient) {

         // caution, check safe-to-multiply here
        uint _numerator  = numerator * 10 ** (precision+1);
        // with rounding of last digit
        uint _quotient =  ((_numerator / denominator) + 5) / 10;
        return ( _quotient);
  }

  
function IsIncluded(bytes16 a, uint8 am, bytes16 b, uint8 bm) view internal returns (bool){
	bytes16 aa;
	bytes16 bb;
	aa=getFirstN(a,am);
	bb=getFirstN(b,am);
	if(aa==bb && am<=bm) return true;
	return false;
	}


function PrefCmpZ(bytes16 a) internal returns (bool){

for(uint i=0; i<a.length; i++)
if(a[i]!=0x00)
return false;
return true;
}


}