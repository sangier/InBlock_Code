pragma solidity ^0.4.24;

import "./InBlock_Data.sol";

contract InBlock_F is InBlock_Data{


function registerPrefix(bytes4 ip, bytes UriToRpki_, bytes uri_, bytes hashFunction_, bytes SignHash_, bytes ROAs_)payable public{

	require((price - 32270100000000000)<=msg.value|| msg.value<=(price + 32270100000000000) , "Price error");

	Certificate memory currentCertificate;
	currentCertificate.o_addr=msg.sender;
	currentCertificate.id=certificates[ip].length+1;
	currentCertificate.date=now;
	currentCertificate.UriToRpki=UriToRpki_;
	currentCertificate.validityT=now+365* 1 days;
	currentCertificate.Roa=ROAs_;
	currentCertificate.info.uri=uri_;
	currentCertificate.info.hashFunction=hashFunction_;
	currentCertificate.info.SignedHash=SignHash_;
	certificates[ip].push(currentCertificate);
	
	owner.transfer(msg.value);

}


function insertArinPk(bytes key) onlyOwner() public notActive(){
ArinPublicKey=key;
}

function insertRipePk(bytes key)onlyOwner() public notActive(){
RipePublicKey=key;
}

function insertLacnicPk(bytes key) onlyOwner() public notActive(){
LacnicPublicKey=key;
}

function insertAfrinicPk(bytes key)onlyOwner() public notActive(){
AfrinicPublicKey=key;
}

function insertApnicPk(bytes key)onlyOwner() public notActive(){
ApnicPublicKey=key;
}



//NB. stop-start <5000
function getPrefixRegistrationIDs(bytes4 ip, uint start, uint stop)public view returns(bytes4,uint[]){
    
	require(stop-start<IDsReadLimit);
	uint stopper=0;
	
	if(stop>certificates[ip].length){
		stopper=certificates[ip].length;
	}
	else stopper=stop;
	
	uint[] memory cIDs=new uint[](stopper-start);
	uint counter=0;
	for(uint i=start; i<stopper; i++){
			cIDs[counter]=certificates[ip][i].id;
			counter++;
		}
	return(ip,cIDs);
}



function countCertificatesIDs(bytes4 ip, address a, uint start, uint stop)view internal returns(uint){

	uint count=0;
	uint stopper=0;
	if(stop<certificates[ip].length){
		stopper=stop;
	}
	else stopper=certificates[ip].length-start;

	for(uint i=start; i<stopper; i++){
			if(certificates[ip][i].o_addr==a){
				count=count+1;
			}
	}
	return count;
}

function countRegistrationNumber(bytes4 ip)public view returns(uint){
	return certificates[ip].length;
}


function renewRegistration(bytes4 ip, uint id) onlyCertOwner(ip,id) payable public returns (uint){
	require(isValid(ip,id));
	require((price - 32270100000000000)<=msg.value|| msg.value<=(price + 32270100000000000) , "Price error");
	uint app1= (certificates[ip][id].validityT+365* 1 days)-now;
	certificates[ip][id].validityT=now+app1;
	owner.transfer(msg.value);	
}

function isValid(bytes4 ip,uint id)internal view returns (bool){
if(certificates[ip][id].validityT>now)return true;
else return false; 
}

function getRegisteredPrefixInfo(bytes4 ip, uint id)public view returns(uint, bytes, bytes, bytes){
	require(isValid(ip,id));
	return(certificates[ip][id].date,certificates[ip][id].info.uri,certificates[ip][id].info.hashFunction,certificates[ip][id].Roa);
}

function getRegistrationUriRpkiSigHash(bytes4 ip, uint id)public view returns(address,bytes, bytes){
	require(isValid(ip,id));
	return(certificates[ip][id].o_addr,certificates[ip][id].UriToRpki,certificates[ip][id].info.SignedHash);
}


function getRegisteredDelegation(bytes4 ip,uint id)public view returns(address,bytes,bytes){
	require(isValid(ip,id));
	return(certificates[ip][id].del.oD_addr,certificates[ip][id].del.uri,certificates[ip][id].del.Roa);
}

function getRegistrationValidityTime(bytes4 ip, uint id) public view returns (uint){
	require(isValid(ip,id));
	return(certificates[ip][id].validityT);
}





function delegatePrefix(bytes4 ip, uint id, address del_a)onlyCertOwner(ip,id) public {
	require(isValid(ip,id));
	require(certificates[ip][id].del.oD_addr==0);
	certificates[ip][id].del.oD_addr=del_a;
}

function removeDelegation(bytes4 ip, uint id)onlyCertOwner(ip,id) public {
	require(isValid(ip,id));
	certificates[ip][id].del.oD_addr=0;
	certificates[ip][id].del.uri="";
	certificates[ip][id].del.Roa="";
	
}


function updatePrefixROA(bytes4 ip, uint id, bytes roa_) onlyCertOwner(ip,id) public {
	require(isValid(ip,id));
	certificates[ip][id].Roa=roa_;
	}

function updatePrefixPolicyURI(bytes4 ip, uint id, bytes uri_) onlyCertOwner(ip,id) public {
	require(isValid(ip,id));
	certificates[ip][id].info.uri=uri_;
}



function updatePrefixDelROA(bytes4 ip, uint id, bytes roa_) onlyDelOwner(ip,id) public {
	require(isValid(ip,id));
	certificates[ip][id].del.Roa=roa_;
}

function updatePrefixDelURI(bytes4 ip, uint id, bytes uri_) onlyDelOwner(ip,id) public {
	require(isValid(ip,id));
	certificates[ip][id].del.uri=uri_;
}




function fakeInsert(uint n)payable public{

for(uint i=0; i<n;i++){
	registerPrefix(0x00201010,"www.unauriabbastanzalunghettacosidavederequantoconsuma.com","www.unauriabbastanzalunghettacosidavederequantoconsuma.com","RSA4096","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","79,111");
}

}
}//END 