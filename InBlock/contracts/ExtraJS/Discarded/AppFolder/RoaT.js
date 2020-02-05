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

    
	
	
    module.exports = function(done) {
		const fs = require('fs'); 
		var InBlock = artifacts.require("InBlock");
		console.log("Getting deployed version of InBlock...")
		const x=InBlock.at(InBlock.address);
		
		
		//OK THIS IS A GOOD STARTING POINT. THEN TAKE CARE BECAUSE THE FOR IS REAPTING EVERYTHING SO YOU MAY HAVE DUPLICATED STUFF. YOU HAVE TO TRY TO DO THE FOR FOR GETTING THE ASSIGNED AND THE ANOTHER FOR THE ROA 
		// WHICH MAY BE INDEPENDENT. 
	    
		//Ciclo for da rivedere
					
				fs.readFile('Assigned.txt', (err, data) => { 
					if (err) throw err;
					var data2=data.toString().split(',');
					console.log(data2);
					console.log("Readiiiign");
					console.log(data2.length);
	                for (i=0; i<data2.length-1;i++){
						console.log(data2[i])
						if(data[i]!=""){
						x.getRoA(data2[i]).then(function(res){
						//console.log("Inizia il nuovo test");
						//console.log(i);
						let tobesaved=res[0]+","+res[2]+","+res[1]+";";
						fs.appendFile('roaTable.txt', tobesaved, (err) => {  
							if (err) throw err;
							//console.log("FILE SAVED");
							})	
						})
						}
					}
				})
				console.log("FINISHED");
	
			}
	
	
