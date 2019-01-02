pragma solidity ^0.4.24;

import "./InBlock_Data.sol";

contract InBlock_F is InBlock_Data{

//*************************************************** GETTER BLOCK FUNCTIONS ****************************************************************************

function getItem(int id) public view returns (bytes16 ip, address o, uint8 mask, int parent, int left, int right,uint _date, bytes a, bytes b, bytes c, bytes d){
		
		parent = blocks[id].parent;
        left = blocks[id].left;
        right = blocks[id].right;
        ip = blocks[id].ip_address;
        o = blocks[id].o_addr;
		mask= blocks[id].mask;
		_date= blocks[id].date;
		a=blocks[id].info.uri;
		b=blocks[id].info.hash;
		c=blocks[id].info.hashFunction;
		d=blocks[id].Roa;
		return(ip,o,mask,parent,left,right,_date,a,b,c,d);

}

	
function countBlock_address(address a, int start, int stop)view internal returns(uint){
uint count=0;
for(int i=start; i<stop+1; i++){
		if(blocks[array_index[i].ind].o_addr==a && !is_expired_id(array_index[i].ind)){
		count=count+1;
		}
		}
	return count;

}

function getIDsBlocks_address(address a,int start, int stop)view public returns(uint[]result){

	uint count=countBlock_address(a,start,stop);
	result = new uint[] (count);
	uint counter=0;
	
	for(int i=start;i<stop+1;i++){
		if(blocks[array_index[i].ind].o_addr==a && !is_expired_id(array_index[i].ind)){
		result[counter]=uint(array_index[i].ind);
		counter=counter+1;
		}
	}
	return result; 

}


function countBlock(int start, int stop)view internal returns(uint){
uint count=0;
for(int i=start; i<stop+1; i++){
		if(!PrefCmpZ(blocks[array_index[i].ind].ip_address) && !is_expired_id(array_index[i].ind)){
		count=count+1;
		}
		}
	return count;

}

function getIDsBlocks(int start, int stop)view public returns(uint[]result){

	uint count=countBlock(start,stop);
	result = new uint[] (count);
	uint counter=0;
	
	for(int i=start;i<stop+1;i++){
		if(!PrefCmpZ(blocks[array_index[i].ind].ip_address) && !is_expired_id(array_index[i].ind)){
		result[counter]=uint(array_index[i].ind);
		counter=counter+1;
		}
	}
	return result; 

}

//******************************************************* FIXED SIZE BLOCK REQUEST FUNCTIONS *******************************************************


//sparse allocation for /32	 NB there is a fixed limit of /32 available blocks.
function sparse_allocation() onlyUsersOrSuper(msg.sender)payable public returns(bool){
		
	require((blockprice - 32270100000000000)<=msg.value|| msg.value<=(blockprice + 32270100000000000) , "Price error");
	
	bool ok=false;
	while(!ok){
		
		if(ID_Index==4096){
			require(ID_expired!=0);
			int idapp=expired_array_index[ID_expired-1].ind;
			bytes16 app2=blocks[idapp].ip_address;
			setBlock_expired(app2,idapp);
			if(Users[msg.sender].privilege==3){
				Users[msg.sender].holding=true;
			}
			if(SuperUsers[msg.sender].privilege==2){
				SuperUsers[msg.sender].holding=true;
			}
			delete_expired();
			ok=true;
			return ok;
		}else{
				bytes16 app = initial_block;
				if(seed%2 !=0) app=setBit(app,128-(base_prefix_mask+1));  
				for(uint8 j=1; j<(allocation_prefix_mask-base_prefix_mask); j++){
					if((seed/(2**(uint(j))))%2!=0) app=setBit(app,128- (base_prefix_mask+1+j));
				}
	
			setBlock(app,allocation_prefix_mask);
			if(Users[msg.sender].privilege==3){
				Users[msg.sender].holding=true;
			}
			if(SuperUsers[msg.sender].privilege==2){
				SuperUsers[msg.sender].holding=true;
			}
			seed=seed+1;
			owner.transfer(msg.value);
			ok=true;
			return ok;
		}
	}
	revert();
}


 
//function to perform a sequent allocation if an user already has a block and want the contiguos one 
function sequent_allocation(bytes16 ip) notStopped() onlyUsersOrSuper(msg.sender) payable public returns (bool){
	
	require(ID_Index<4096);
	require((blockprice - 32270100000000000)<=msg.value || msg.value<=(blockprice + 32270100000000000) , "Price error");
	int id= find(ip,allocation_prefix_mask);
	require(id!=-1,"The block doesn't exist");
	require(!is_expired_id(id));
	require(msg.sender==blocks[id].o_addr, "You are not Authorized");
		
		if(!getBit(ip,128-allocation_prefix_mask)){
				ip=setBit(ip,128-allocation_prefix_mask);
		}else{	
				ip=clearBit(ip,128-allocation_prefix_mask);
				uint8 i=1;
				while(i<allocation_prefix_mask-base_prefix_mask){
					
						if(getBit(ip,128-(allocation_prefix_mask-i))){
								ip=clearBit(ip,128-(allocation_prefix_mask-i));
								i++;
						}else{
								ip=setBit(ip,128-(allocation_prefix_mask-i));
								i=allocation_prefix_mask-base_prefix_mask;
							}
						}
			  }
			  
		
		int id1= find(ip,allocation_prefix_mask);
		if(id1!=-1 && is_expired_id(id)){
				setBlock_expired(ip,id1);
				if(Users[msg.sender].privilege==3){
				Users[msg.sender].holding=true;
			}
			if(SuperUsers[msg.sender].privilege==2){
				SuperUsers[msg.sender].holding=true;
			}
				owner.transfer(msg.value);
				return true;
		}else{
				require(id1==-1);
				setBlock(ip,allocation_prefix_mask);
				if(Users[msg.sender].privilege==3){
				Users[msg.sender].holding=true;
			}
			if(SuperUsers[msg.sender].privilege==2){
				SuperUsers[msg.sender].holding=true;
			}
				owner.transfer(msg.value);
				return true;
			}
		
			revert();
}

//******************************************************* BLOCK RENEWAL FUNCTION *******************************************************


function Renew_Block(bytes16 ip) notStopped() onlyUsersOrSuper(msg.sender) payable public returns (bool,uint){
	
	require(msg.value==blockprice, "Price Error.");
	
	int id=find(ip,allocation_prefix_mask);
	require(id!=-1);
	require(!is_expired_id(id));
	require(msg.sender==blocks[id].o_addr, "You are not the owner of the block");
	uint app1= (blocks[id].date+365* 1 days)-now;
	blocks[id].date=now+app1;	
	owner.transfer(msg.value);
	return(true,blocks[id].date);
}


//******************************************************* BLOCK RECOVER FUNCTION *******************************************************

function countBlock_expired(int start, int stop)view internal returns(uint){
uint count=0;
for(int i=start; i<stop; i++){
		if(is_expired_id(array_index[i].ind)){
		count=count+1;
		}
		}
	return count;

}

function getIDsBlocks_expired(int start, int stop)view public returns(uint[]result){

	uint count=countBlock_expired(start,stop);
	result = new uint[] (count);
	uint counter=0;
	
	for(int i=start;i<stop;i++){
		if(is_expired_id(array_index[i].ind)){
		result[counter]=uint(array_index[i].ind);
		counter=counter+1;
		}
	}
	return result; 

}


function recover_expired_block(int id)onlyOwner()public {

	require(is_expired_id(id));
	blocks[id].mask=0;
	blocks[id].o_addr=0x00;
	blocks[id].date=0;
	blocks[id].info.uri="";
	blocks[id].info.hashFunction="";
	blocks[id].info.hash="";
	blocks[id].Roa="";

	expired_array_index[ID_expired].ind=id;
	ID_expired=ID_expired+1;

}


function getRecovered()view public returns(uint[]result){

	uint count=uint(ID_expired);
	result = new uint[] (count);
	uint counter=0;
	
	for(int i=0;i<ID_expired;i++){
			result[counter]=uint(expired_array_index[i].ind);
			counter=counter+1;
		}
	
	return result; 

}

function delete_expired()internal{

	delete expired_array_index[ID_expired];
	ID_expired=ID_expired-1;

}

//******************************************************* SET INFO FUNCTIONS *******************************************************
function setInfoBlock(bytes16 ip, bytes uri, bytes hashFunction, bytes hash) onlySuperUsers(msg.sender) public {
	
	int id=find(ip,allocation_prefix_mask);
	require(id!=-1);
	require(!is_expired_id(id));
	blocks[id].info.uri=uri;
	blocks[id].info.hashFunction=hashFunction;
	blocks[id].info.hash=hash;
			
}


//******************************************************* ASes FUNCTIONS *******************************************************

function getBlockASes(bytes16 ip)view public returns(bytes){
	
	int id=find(ip,allocation_prefix_mask);
	require(id!=-1);
	require(!is_expired_id(id));
	return blocks[id].Roa;
}


function setRoaBlock(bytes16 ip, bytes ASes) onlySuperUsers(msg.sender) public {
					
	int id=find(ip,allocation_prefix_mask);
	require(id!=-1);
	require(!is_expired_id(id));
	require(msg.sender==blocks[id].o_addr);
	blocks[id].Roa=ASes;
}


//*****************************************************BLOCKS SETTER*************************************************************
	
function setBlock(bytes16 ip,uint8 mask)internal {

	int idCurrent=0;
	int idNext=0;
	int i=0;
	while(i<allocation_prefix_mask-base_prefix_mask-1){
		if(!getBit(ip,(128-(base_prefix_mask+uint8(i)+1)))){
				
				idCurrent=idNext;
				if(blocks[idCurrent].left==0){
						idNext=ID;
						blocks[idCurrent].left=idNext;
						blocks[idNext].parent=idCurrent;
						ID=ID+1;
				}else{
					idNext=blocks[idCurrent].left;
				}
		}else{
				idCurrent=idNext;
					if(blocks[idCurrent].right==0){
							idNext=ID;
							blocks[idCurrent].right=idNext;
							blocks[idNext].parent=idCurrent;
							ID=ID+1;
					}else{
						idNext=blocks[idCurrent].right;
					}
			}
	
		i=i+1;
	}

	if(!getBit(ip,128-allocation_prefix_mask)){
				var ind=array_index[ID_Index];
				idCurrent=idNext;
				if(blocks[idCurrent].left==0){
						idNext=ID;
						blocks[idCurrent].left=idNext;
						blocks[idNext].parent=idCurrent;
						ID=ID+1;
						blocks[idNext].ip_address=ip;
						blocks[idNext].o_addr=msg.sender;
						blocks[idNext].mask=mask;
						blocks[idNext].date=now;
						blocks[idNext].ID_delegated=1;
						array_index[ID_Index].ind=idNext;
						ID_Index=ID_Index+1;
				}else{
					idNext=blocks[idCurrent].left;
					blocks[idNext].ip_address=ip;
					blocks[idNext].o_addr=msg.sender;
					blocks[idNext].mask=mask;
					blocks[idNext].date=now;
					blocks[idNext].ID_delegated=1;
					array_index[ID_Index].ind=idNext;
					ID_Index=ID_Index+1;
				}
	}else{
			idCurrent=idNext;
				if(blocks[idCurrent].right==0){
						idNext=ID;
						blocks[idCurrent].right=idNext;
						blocks[idNext].parent=idCurrent;
						ID=ID+1;
						blocks[idNext].ip_address=ip;
						blocks[idNext].o_addr=msg.sender;
						blocks[idNext].mask=mask;
						blocks[idNext].date=now;
						blocks[idNext].ID_delegated=1;
						array_index[ID_Index].ind=idNext;
						ID_Index=ID_Index+1;
				}else{
					idNext=blocks[idCurrent].right;
					blocks[idNext].ip_address=ip;
					blocks[idNext].o_addr=msg.sender;
					blocks[idNext].mask=mask;
					blocks[idNext].date=now;
					blocks[idNext].ID_delegated=1;
					array_index[ID_Index].ind=idNext;
					ID_Index=ID_Index+1;
				}
		}
}


//THIS FUNCTION HAS TO BE CHANGED WITH THE NEW DATASTRUCTURE MAINTAING A LIST OF EXPIRED BLOCKS 
function setBlock_expired(bytes16 ip, int id) internal {
		
	blocks[id].ip_address=ip;
	blocks[id].o_addr=msg.sender;
	blocks[id].mask=allocation_prefix_mask;
	blocks[id].date=now;
	blocks[id].Roa="";
	blocks[id].info.uri="";
	blocks[id].info.hashFunction="";
	blocks[id].info.hash="";
	
}


}//END 