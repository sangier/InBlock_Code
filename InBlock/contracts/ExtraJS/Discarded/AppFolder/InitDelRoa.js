  // the transaction count does not include *pending* transactions
  // but is a good starting point for the nonce

function timeConverter(UNIX_timestamp){
  var a = new Date(UNIX_timestamp);
  var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  var year = a.getFullYear();
  var month = months[a.getMonth()];
  var date = a.getDate();
  var hour = a.getHours();
  var min = a.getMinutes();
  var sec = a.getSeconds();
  var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec ;
  return time;
}

    
	
	
async function s2(){    
		
		console.log("INTO s2 2");
		const fs = require('fs'); 
		var InBlock = artifacts.require("InBlock");
		console.log("Getting deployed version of InBlock...")
		const x=InBlock.at(InBlock.address);
		
		
		//OK THIS IS A GOOD STARTING POINT. THEN TAKE CARE BECAUSE THE FOR IS REAPTING EVERYTHING SO YOU MAY HAVE DUPLICATED STUFF. YOU HAVE TO TRY TO DO THE FOR FOR GETTING THE ASSIGNED AND THE ANOTHER FOR THE ROA 
		// WHICH MAY BE INDEPENDENT. 
	    
		//Ciclo for da rivedere
					
				await fs.readFile('Assigned.txt', async function(err, data) { 
					if (err) throw err;
					var data2=data.toString().split(',');
					console.log(data2);
					console.log("Readiiiign");
					console.log(data2.length);
	                for (i=0; i<data2.length-1;i++){
						console.log(data2[i])
						if(data[i]!=""){
						await x.getRoA(data2[i]).then( async function(res){
						//console.log("Inizia il nuovo test");
						//console.log(i);
						let tobesaved=res[0];
						console.log(res[0])
						x.delegatePrefix(tobesaved,tobesaved, 48, web3.eth.accounts[2])							//console.log("FILE SAVED");
					    console.log("Qui arrivo") 
						return;
						})
						}
					}
					return;
				
				})
				console.log("FINISHED");
				return;
			}


s2();

/*     
async function s1(){	
	
    module.exports = async function(done) {
		const fs = require('fs'); 
		var InBlock = artifacts.require("InBlock");
		console.log("Getting deployed version of InBlock...")
		const x=InBlock.at(InBlock.address);
		
		
		//OK THIS IS A GOOD STARTING POINT. THEN TAKE CARE BECAUSE THE FOR IS REAPTING EVERYTHING SO YOU MAY HAVE DUPLICATED STUFF. YOU HAVE TO TRY TO DO THE FOR FOR GETTING THE ASSIGNED AND THE ANOTHER FOR THE ROA 
		// WHICH MAY BE INDEPENDENT. 
	    
		//Ciclo for da rivedere 
		for (j=0;j<9;j++){
        
	   await x.delegate_block(parent_ip, del_ip, 48, web3.eth.accounts[2]).then(async function(res){
			
		if (res!=""){
			//console.log(res)
			let tobesaved=res.toString()+",";
			fs.appendFile('Assigned.txt', tobesaved, (err) => {  
				if (err) throw err;
				console.log("FILE SAVED:"+j);
		})
		}	
		return;
		})
		console.log("FINISHED: "+j);
		}
		
		s2();
		console.log("Vediamo dove finisce")
    return;    
	};
}


//return;
//}

 s1();

	
delegate_block(parent_ip, del_ip, mask, delegated_address) */