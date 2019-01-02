pragma solidity ^0.4.24;

import "./InBlock_Data.sol";

contract InBlock_F_del is InBlock_Data{

//******************************************************* DELEGATION FUNCTIONS *******************************************************

 
//To perform a delegation. NB the sender of the transaction has to be the owner of the parent_ip 
function delegate_block(bytes16 _parent_ip, bytes16 del_ip, uint8 bar, address delegated_address) notStopped() onlyUsersOrSuper(msg.sender) public {
	
	require(bar<=max_del);
	require(IsIncluded(_parent_ip, allocation_prefix_mask, del_ip, bar), "The entered ip is out of range");
	int id=find(_parent_ip,allocation_prefix_mask);
	require(msg.sender==blocks[id].o_addr, "Operation not authorized!");
	require(is_consistent(_parent_ip, del_ip, bar), "The entered block is part of another existing block");
	int id2=del_find(_parent_ip,del_ip,bar);
	
	if(id2!=-1 && id2!=-2){ 
			set_del_Block(_parent_ip, del_ip, bar, delegated_address);
			if(Users[delegated_address].privilege==3){
				Users[delegated_address].holding=true;
			}
			if(SuperUsers[delegated_address].privilege==2){
				SuperUsers[delegated_address].holding=true;
			}
	}else{
			set_del_Block(_parent_ip, del_ip, bar, delegated_address);
			if(Users[delegated_address].privilege==3){
				Users[delegated_address].holding=true;
			}
			if(SuperUsers[delegated_address].privilege==2){
				SuperUsers[delegated_address].holding=true;
			}
		}

}

//function to delete the revoked entry. It can only be performed by the owner of the parent block

function revoke_delegation(bytes16 parent_ip, bytes16 del_ip,uint8 mask) notStopped() onlyUsersOrSuper(msg.sender) public {	
			
			int id=find(parent_ip,allocation_prefix_mask);
			require(id!=-1);
			require(!is_expired_id(id));
			require(msg.sender==blocks[id].o_addr, "Operation not Authorized!!");
			int id2=del_find(parent_ip,del_ip,mask);
			require(id2!=-1 && id2!=-2);
			blocks[id].del_blocks[id2].ip_address=0x00;
			blocks[id].del_blocks[id2].o_addr=0x00;
			blocks[id].del_blocks[id2].mask=0;
			blocks[id].del_blocks[id2].Roa="";
			blocks[id].del_blocks[id2].info.uri="";
			blocks[id].del_blocks[id2].info.hashFunction="";
			blocks[id].del_blocks[id2].info.hash="";
			
			int idNext=id2;
			int idCurrent=id2;
		
			
			for(int i=0; i<mask-allocation_prefix_mask+1; i++){
				idCurrent=idNext;
				idNext=blocks[id].del_blocks[idCurrent].parent;
				if(!getBit(del_ip,128-mask-uint8(i))){
						if(blocks[id].del_blocks[idNext].right!=0){
								if(PrefCmpZ(blocks[id].del_blocks[blocks[id].del_blocks[idNext].right].ip_address)){
										blocks[id].del_blocks[idNext].ip_address=0x00;
								}
						}else{
								if(PrefCmpZ(blocks[id].del_blocks[blocks[id].del_blocks[idNext].left].ip_address)){blocks[id].del_blocks[idNext].ip_address=0x00;}
							}
				}else{
						if(blocks[id].del_blocks[idNext].left!=0){
								if(PrefCmpZ(blocks[id].del_blocks[blocks[id].del_blocks[idNext].left].ip_address)){
										blocks[id].del_blocks[idNext].ip_address=0x00;
								}
						}else{
								if(PrefCmpZ(blocks[id].del_blocks[blocks[id].del_blocks[idNext].right].ip_address)){blocks[id].del_blocks[idNext].ip_address=0x00;}
							}				
					}		
			}			
}

							
//To check the consistance of delegate_blocks

function is_consistent(bytes16 ip_parent, bytes16 ip, uint8 mask) view internal returns(bool){
	
	int id=find(ip_parent,allocation_prefix_mask);
	require(id!=-1);
	require(!is_expired_id(id));
		
	int idCurrent=0;
	int idNext=0;
	int i=0;
	bool exit=false;
	bool ok=false;
		while(i<(max_del-allocation_prefix_mask)+1 && exit==false){
				if(!getBit(ip,(128-(allocation_prefix_mask+uint8(i)+1)))){
						idCurrent=idNext;
						if(1+mask-allocation_prefix_mask==i){
								if(!PrefCmpZ(blocks[id].del_blocks[idCurrent].ip_address) || !PrefCmpZ(blocks[id].del_blocks[blocks[id].del_blocks[idCurrent].left].ip_address) || !PrefCmpZ(blocks[id].del_blocks[blocks[id].del_blocks[idCurrent].right].ip_address))ok=true;
						}
						if(!PrefCmpZ(blocks[id].del_blocks[idCurrent].ip_address) && blocks[id].del_blocks[idCurrent].mask!=0)ok=true;
						if(blocks[id].del_blocks[idCurrent].left==0){
								exit=true;
						}else{
								idNext=blocks[id].del_blocks[idCurrent].left;
							}
				}else{
						idCurrent=idNext;
						if(1+mask-allocation_prefix_mask==i){
								if(!PrefCmpZ(blocks[id].del_blocks[idCurrent].ip_address) || !PrefCmpZ(blocks[id].del_blocks[blocks[id].del_blocks[idCurrent].left].ip_address) || !PrefCmpZ(blocks[id].del_blocks[blocks[id].del_blocks[idCurrent].right].ip_address))ok=true;
						}
						if(!PrefCmpZ(blocks[id].del_blocks[idCurrent].ip_address) && blocks[id].del_blocks[idCurrent].mask!=0)ok=true;
						if(blocks[id].del_blocks[idCurrent].right==0){
							exit=true;
						}else{
								idNext=blocks[id].del_blocks[idCurrent].right;
							}		
					}
	
		i=i+1;
		}
	if(ok)return false;
	else return true;
}


//*****************************************************DELEGATED BLOCKS SETTER*************************************************************

function set_del_Block(bytes16 ip, bytes16 ip2, uint8 mask,address delegated)internal{
	
	int id=find(ip,allocation_prefix_mask);
	require(id!=-1);
	require(!is_expired_id(id));
	require(msg.sender==blocks[id].o_addr);
	int idCurrent=0;
	int idNext=0;
	int i=0;
	
		while(i<mask-allocation_prefix_mask-1){
			bytes16 app=getFirstN(ip2,allocation_prefix_mask+uint8(i)+1);
				if(!getBit(ip2,(128-(allocation_prefix_mask+uint8(i)+1)))){
						idCurrent=idNext;
						if(blocks[id].del_blocks[idCurrent].left==0){
								idNext=blocks[id].ID_delegated;
								blocks[id].del_blocks[idCurrent].ip_address=app;
								blocks[id].del_blocks[idCurrent].left=idNext;
								blocks[id].del_blocks[idNext].parent=idCurrent;
								blocks[id].ID_delegated=blocks[id].ID_delegated+1;
						}else{
								if(PrefCmpZ(blocks[id].del_blocks[idNext].ip_address)){blocks[id].del_blocks[idNext].ip_address=app;}
								idNext=blocks[id].del_blocks[idCurrent].left;
					
							}
				}else{
						idCurrent=idNext;
						if(blocks[id].del_blocks[idCurrent].right==0){
								idNext=blocks[id].ID_delegated;
								blocks[id].del_blocks[idCurrent].ip_address=app;
								blocks[id].del_blocks[idCurrent].right=idNext;
								blocks[id].del_blocks[idNext].parent=idCurrent;
								blocks[id].ID_delegated=blocks[id].ID_delegated+1;
						}else{
								if(PrefCmpZ(blocks[id].del_blocks[idNext].ip_address)){blocks[id].del_blocks[idNext].ip_address=app;}
								idNext=blocks[id].del_blocks[idCurrent].right;
					}
				}
	
		i=i+1;
		}

		if(!getBit(ip2,128-mask)){
				app=getFirstN(ip2,mask);
				var ind=blocks[id].del_array_index[blocks[id].del_ID_Index];		
				idCurrent=idNext;
					if(blocks[id].del_blocks[idCurrent].left==0){
							if(blocks[id].del_blocks[idCurrent].right==0){
									blocks[id].del_blocks[idCurrent].ip_address=app;
							}
							idNext=blocks[id].ID_delegated;
							blocks[id].del_blocks[idCurrent].left=idNext;
							blocks[id].del_blocks[idNext].parent=idCurrent;
							blocks[id].ID_delegated=blocks[id].ID_delegated+1;
							blocks[id].del_blocks[idNext].ip_address=ip2;
							blocks[id].del_blocks[idNext].o_addr=delegated;
							blocks[id].del_blocks[idNext].mask=mask;
							blocks[id].del_array_index[blocks[id].del_ID_Index].ind=idNext;
							blocks[id].del_ID_Index=blocks[id].del_ID_Index+1;
					}else{
						idNext=blocks[id].del_blocks[idCurrent].left;
						if(PrefCmpZ(blocks[id].del_blocks[idCurrent].ip_address)){ blocks[id].del_blocks[idCurrent].ip_address=app;}
						blocks[id].del_blocks[idNext].ip_address=ip2;
						blocks[id].del_blocks[idNext].o_addr=delegated;
						blocks[id].del_blocks[idNext].mask=mask;
						blocks[id].del_array_index[blocks[id].del_ID_Index].ind=idNext;
						blocks[id].del_ID_Index=blocks[id].del_ID_Index+1;
					}
					}else{
							idCurrent=idNext;
							if(blocks[id].del_blocks[idCurrent].right==0){
									if(blocks[id].del_blocks[idCurrent].left==0){
									blocks[id].del_blocks[idCurrent].ip_address=app;
									}
							idNext=blocks[id].ID_delegated;
							blocks[id].del_blocks[idCurrent].right=idNext;
							blocks[id].del_blocks[idNext].parent=idCurrent;
							blocks[id].ID_delegated=blocks[id].ID_delegated+1;
							blocks[id].del_blocks[idNext].ip_address=ip2;
							blocks[id].del_blocks[idNext].o_addr=delegated;
							blocks[id].del_blocks[idNext].mask=mask;
				
							blocks[id].del_array_index[blocks[id].del_ID_Index].ind=idNext;
							blocks[id].del_ID_Index=blocks[id].del_ID_Index+1;
							}else{
									idNext=blocks[id].del_blocks[idCurrent].right;
									if(PrefCmpZ(blocks[id].del_blocks[idCurrent].ip_address)){ blocks[id].del_blocks[idCurrent].ip_address=app;}
									blocks[id].del_blocks[idNext].ip_address=ip2;
									blocks[id].del_blocks[idNext].o_addr=delegated;
									blocks[id].del_blocks[idNext].mask=mask;
									blocks[id].del_array_index[blocks[id].del_ID_Index].ind=idNext;
									blocks[id].del_ID_Index=blocks[id].del_ID_Index+1;
								}
						}
}



function del_find(bytes16 ip, bytes16 ip2, uint8 _mask) public view returns (int) {
		
		int id=find(ip,allocation_prefix_mask);
		if(id==-1)return -1;
		if(is_expired_id(id))return -1;	
		int id1 = 0;
		int i=0;
		bool ok=false;
       
      
		while (i<(_mask-allocation_prefix_mask)+1) {
				if (ip2 == blocks[id].del_blocks[id1].ip_address && _mask==blocks[id].del_blocks[id1].mask) {
						ok=true;
						return id1;
				}
       
				if(!getBit(ip2,(128-(allocation_prefix_mask+uint8(i)+1)))){
						id1 = blocks[id].del_blocks[id1].left;
				}else{
						id1 = blocks[id].del_blocks[id1].right;
					}
			i=i+1;
		}
		if(ok)return id1; 
		else return -2;
}


//***********************************************GETTER DELEGATED BLOCK FUNCTIONS *******************************************************************************


function get_del_Block_id(int id, int id2) view public returns(bytes16, address,uint8,int,int,int){
	
	require(!is_expired_id(id));
	return(blocks[id].del_blocks[id2].ip_address,blocks[id].del_blocks[id2].o_addr,blocks[id].del_blocks[id2].mask,blocks[id].del_blocks[id2].parent,blocks[id].del_blocks[id2].left,blocks[id].del_blocks[id2].right);
}

function count_del_Block(bytes16 ip, int start, int stop)view internal returns(uint){
	int id=find(ip,allocation_prefix_mask);
	uint count=0;
	for(int i=start; i<stop+1; i++){
			int a=blocks[id].del_array_index[i].ind;
			bytes16 test= blocks[id].del_blocks[a].ip_address;
			if(blocks[id].del_blocks[a].mask!=0){
				count=count+1;
			}
	}
	return count;

}


function getIDs_del_Blocks(bytes16 ip, int start, int stop)view public returns(uint[]result){
	
	int id=find(ip,allocation_prefix_mask);
	uint count=count_del_Block(ip,start,stop);
	result = new uint[] (count);
	uint counter=0;
	
	for(int i=start;i<stop+1;i++){
			if(blocks[id].del_blocks[blocks[id].del_array_index[i].ind].mask!=0){
				result[counter]=uint(blocks[id].del_array_index[i].ind);
				counter=counter+1;
			}
	}
	return result; 

}

//******************************************************************************INFO AND ROA FUNCTIONS ******************************************************************************************************
function setInfo_del_Block(bytes16 ip_parent, bytes16 ip, uint8 mask, bytes uri, bytes hashFunction, bytes hash) onlySuperUsers(msg.sender) public {
			
			int id= find(ip_parent,allocation_prefix_mask);
			require(id!=-1);
			require(!is_expired_id(id));
			int id2= del_find(ip_parent, ip, mask);
			require(id2!=-1 && id2!=-2);
			blocks[id].del_blocks[id2].info.uri=uri;
			blocks[id].del_blocks[id2].info.hashFunction=hashFunction;
			blocks[id].del_blocks[id2].info.hash=hash;
}


function setRoa_del_Block(bytes16 ip_parent, bytes16 ip, uint8 mask, bytes ASes) onlySuperUsers(msg.sender) public {
			
			int id= find(ip_parent,allocation_prefix_mask);
			require(id!=-1);
			require(!is_expired_id(id));
			int id2= del_find(ip_parent, ip, mask);
			require(id2!=-1 && id2!=-2);
			require(msg.sender==blocks[id].del_blocks[id2].o_addr);
			blocks[id].del_blocks[id2].Roa=ASes;
			}


function get_del_BlockASes(bytes16 ip_parent, bytes16 ip, uint8 mask)view public returns(bytes){
	
			int id= find(ip_parent,allocation_prefix_mask);
			require(id!=-1);
			require(!is_expired_id(id));
			int id2= del_find(ip_parent, ip, mask);
			require(id2!=-1 && id2!=-2);
			return blocks[id].del_blocks[id2].Roa;
	

}



}//END


