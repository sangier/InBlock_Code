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
    Nexec=100;
    acc=0;
	//accMax=0;
	const fs = require('fs'); 
	var SimpleStorage = artifacts.require("InBlock");
	module.exports = function(done) {
	//console.log("Getting deployed version of InBlock...")
	timeMax=0;
	initTime=new Date().getTime();
    //this for is not needed
   	
	SimpleStorage.deployed().then(function(instance) {
        var instancee=instance;
		now=Date.now();
		//console.log(timeConverter(now));
		//console.log(now);
        return instancee.getPrefixRegistrationIDs("0x00201010",acc,Nexec).then(function(result) {
        //console.log("Transaction A:", result[1][0]);
		//console.log("Transaction B:", result);
		//console.log("Transaction C:", result);
		
		for (let i = 0; i < Nexec; i++) {
	
		initTimeLocal=new Date().getTime();
		t=Math.floor(new Date().getTime()/1000)
		//console.log('Iteration '+t)
		//console.log("Running Transaction");
        //console.log("Issued Call!");
        done();
		
	    return instancee.getRegistrationUriRpkiSigHash("0x00201010",result[1][i]).then(function(result2) {
		//console.log("Transaction A:", result2);
		//console.log(t)
		
		//return instancee.getCertificateUserKeyMessage("0x00201010",result[1][0]).then(function(result3) {
		//console.log("Transaction A:", result3);
		
		//console.log("CertReading,"+t+","+i+","+result[0]+","+result2+","+result3+"\n");
		finishTime=new Date().getTime()//Date.now();
		
		if(finishTime-initTime>timeMax){
			timeMax=finishTime-initTime;
		}
		
		//if(finishTime-initTimeLocal>accMax){
	//		accMax=finishTime-initTimeLocal
	//	}
		//acc=acc+finishTime-initTime;
		
		//console.log('InitTime '+initTime)
		//console.log('InitTimeLocal '+initTimeLocal)
		//console.log('MaxDiffBetween calls '+accMax)
		//console.log('TimeElapsed '+(finishTime-initTime))
		//console.log('MaxTimeElapsed '+timeMax)
		
		if(i+1==Nexec){
		let tobesaved=Nexec+","+timeMax+"\n";
		fs.appendFile('DataNoCtr.txt', tobesaved, (err) => {  
    // throws an error, you could also catch it here
    if (err) throw err;

    // success case, the file was saved
    console.log('ElapsedTime Data saved!');
});	
		}
		
    }).catch(function(e) {
        console.log(e);
        done();
    });
	
	
  }
  
  console.log(acc)
  console.log("Final Finished")
	})})}

	
