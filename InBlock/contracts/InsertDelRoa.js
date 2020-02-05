//This script server to insert all the delegated roas

function readdirAsyncS4() {
  const fs = require('fs'); 
  return new Promise(function (resolve, reject) {
    fs.readFile("Assigned_del.txt", function (error, result) {
      if (error) {
        reject(error);
		
      } else {
		resolve(result);
      }
    });
  });
}


async function s4(){	
	
	//TAKE ALL ROA DELEGATED 
	console.log("Calling S1()")
	const fs = require('fs'); 
	var InBlock = artifacts.require("InBlock");
	console.log("Getting deployed version of InBlock...")
	const x=InBlock.at(InBlock.address);
	data=await readdirAsyncS4();
	
	var data2=data.toString().split(';');	
	console.log("Readiiiign");
	for (i=0; i<(data2.length-1);i++){
		appD=data2[i].toString().split(',');
		    for(j=1;j<appD.length; j++){
				await x.setDelegatedPrefixRoAID(appD[0],appD[j],"'"+j+1+",'",{from:web3.eth.accounts[2]})
					console.log("Iteration Number: "+i+" , "+j)
			}
	}	
	return("S4() is finally over");
}




async function t1(){
	
	module.exports = async function(done) {
		const fs = require('fs'); 
		console.log("t1 is called");
		
		const promise4=await s4();
		console.log("After some times s4 returns: ")
		console.log(promise4);    
		done("Delegated ROA exited with succcess!!!!")
	};
	
	
	
}

t1();
