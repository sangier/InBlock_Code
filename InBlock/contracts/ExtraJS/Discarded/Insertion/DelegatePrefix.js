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
						//console.log(res[0])
						x.delegatePrefix(tobesaved,tobesaved, 48, web3.eth.accounts[2])							//console.log("FILE SAVED");
					    console.log("Iteration Number: "+j) 
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

