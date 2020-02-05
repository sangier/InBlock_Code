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


async function s3(){
		
		module.exports = async function(done) {
			const fs = require('fs'); 
			var InBlock = artifacts.require("InBlock");
			console.log("Getting deployed version of InBlock...")
			const x=InBlock.at(InBlock.address);
			
			for(i=0; i<2; i++){
				for (j=0;j<9;j++){
					await x.getIDsDelBlocksID(i,0+512*j,511+512*j).then(async function(res){
						if (res!=""){
			//console.log(res)
							let tobesaved=+i+","+res.toString()+";";
							fs.appendFile('Assigned_del.txt', tobesaved, (err) => {  
							if (err) throw err;
							console.log("FILE SAVED:"+j);
							})
						}
						else j=9
						return;
					})
				console.log("FINISHED internal for: "+j+","+i);
				}
			console.log("External for")
            };
		console.log("Faccio partire il delRoaT.js");	
		s4();
		console.log("delRoaT finito?")
		return;
		}
	//return;
}


async function s4(){

console.log("DENTRO S4");

    const fs = require('fs'); 
	var InBlock = artifacts.require("InBlock");
	console.log("Getting deployed version of InBlock...")
	const x=InBlock.at(InBlock.address);
							
	await fs.readFile('Assigned_del.txt', async function(err, data) { 
		if (err) throw err;
		var data2=data.toString().split(';');
		console.log("Readiiiign");
					
        for (i=0; i<(data2.length-1);i++){
			appD=data2[i].toString().split(',');
			//	console.log("Test number "+i+" Result "+appD)					
    		for(j=1;j<appD.length; j++){
				await x.getDelegatedPrefixRoAID(appD[0],appD[j]).then(async function(res){
				//console.log("Inizia il nuovo test");
				//console.log(i);						
				let tobesaved=res[0]+","+res[2]+","+res[1]+";";
					fs.appendFile('delRoaTable.txt', tobesaved, (err) => {  
						if (err) throw err;
					})
                return;					
				})
						 
			}
	
		}
	return;
	})
console.log("FINISHED");
return;	
}

//MAIN 
s3();








