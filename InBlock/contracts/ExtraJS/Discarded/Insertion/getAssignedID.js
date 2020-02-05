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

    
	
	
async function s1(){	
	
    module.exports = async function(done) {
		const fs = require('fs'); 
		var InBlock = artifacts.require("InBlock");
		console.log("Getting deployed version of InBlock...")
		const x=InBlock.at(InBlock.address);
		
		
		for (j=0;j<9;j++){
			await x.getIDsAssignedBlocks(0+512*j,511+512*j).then(async function(res){
				if (res!=""){
			//console.log(res)
					let tobesaved=res.toString()+",";
					fs.appendFile('Assigned.txt', tobesaved, (err) => {  
						if (err) throw err;
						console.log("FILE SAVED:"+j);
					})
				}	
			
			})
			
			console.log("FINISHED: "+j);
		}
		//s2();
		console.log("Vediamo dove finisce")
		done()    
		};
}
	
s1();