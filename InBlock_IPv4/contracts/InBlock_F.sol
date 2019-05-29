pragma solidity ^0.4.24;

import "./InBlock_Data.sol";

contract InBlock_F is InBlock_Data{


function insertCertificate(bytes4 ip, bytes uri_, bytes hashFunction_, bytes hash_, bytes ROAs_)payable public{

require((price - 32270100000000000)<=msg.value|| msg.value<=(price + 32270100000000000) , "Price error");

Certificate memory currentCertificate;

currentCertificate.o_addr=msg.sender;
currentCertificate.id=ID_Index;
currentCertificate.mask=base_certificate_mask;
currentCertificate.date=now;
currentCertificate.Roa=ROAs_;
currentCertificate.info.uri=uri_;
currentCertificate.info.hashFunction=hashFunction_;
currentCertificate.info.hash=hash_;
ID_Index=ID_Index+1;
certificates[ip].push(currentCertificate);

}


function readCertificateOwners(bytes4 ip,uint start,uint stop)public view returns(bytes4,address[]){
	
	require(stop-start<OwnersReadLimit);
	uint stopper=0;
	
	if(stop>certificates[ip].length){
		stopper=certificates[ip].length;
	}
	else stopper=stop;
	
	uint count=countCertificatesOwners(ip,start,stopper);
	address[] memory cOwners=new address[](count);
	uint counter=0;
	for(uint i=0; i<stopper; i++){
		cOwners[counter]=certificates[ip][i].o_addr;
		counter++;
	}
	return(ip,cOwners);
}




function readCertificateIDsByOwner(bytes4 ip,address a,uint start,uint stop)public view returns(bytes4,uint[]){
	
	require(stop-start<IDsReadByOwnerLimit);
	uint stopper=0;
	if(stop>certificates[ip].length){
		stopper=certificates[ip].length;
	}
	else stopper=stop;
	
	uint count=countCertificatesIDs(ip,a,start,stop);
	uint[] memory cIDs=new uint[](count);
	uint counter=0;
	for(uint i=0; i<stopper; i++){
		if(certificates[ip][i].o_addr==a){
			cIDs[counter]=certificates[ip][i].id;
			counter++;
		}

	}
	return(ip,cIDs);
}

//NB. stop-start <5000
function readCertificateIDs(bytes4 ip, uint start, uint stop)public view returns(bytes4,uint[]){
    
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



function countCertificatesOwners(bytes4 ip, uint start, uint stop)view internal returns(uint){
	uint count=0;
	uint stopper=0;
	if(stop<certificates[ip].length){
		stopper=stop;
	}
	else stopper=certificates[ip].length-start;

	for(uint i=start; i<stopper; i++){
		count=count+1;
	}
	return count;
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

function countCertificatesIP(bytes4 ip)public view returns(uint){
	return certificates[ip].length;
}




function getCertificates(bytes4 ip, uint id)public view returns(uint, address, bytes, bytes, bytes, bytes){
	
	return(certificates[ip][id].date,certificates[ip][id].o_addr,certificates[ip][id].info.uri,certificates[ip][id].info.hashFunction,certificates[ip][id].info.hash,certificates[ip][id].Roa);
}



function updateCertificateROA_Info(bytes4 ip, uint id, bytes roa_, bytes uri_, bytes hash_, bytes hashFunction_)public {

	require(msg.sender==certificates[ip][id].o_addr);
	certificates[ip][id].Roa=roa_;
	certificates[ip][id].info.uri=uri_;
	certificates[ip][id].info.hashFunction=hashFunction_;
	certificates[ip][id].info.hash=hash_;
}


//testfunction

function iterateInsert(uint iteration)public{

for(uint i =0; i<iteration;i++){
insertCertificate(0xc0000100,"www.fabiolaIsTheMostBeautifulGirlInTheWorld.com","sha256","aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","10082017");
}
}

}//END 