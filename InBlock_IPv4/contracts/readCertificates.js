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

	const fs = require('fs'); 
	var SimpleStorage = artifacts.require("InBlock");
	module.exports = function(done) {
	console.log("Getting deployed version of InBlock...")
  for (let i = 0; i < 10; i++) {
    SimpleStorage.deployed().then(function(instance) {
        var instancee=instance;
		now=Date.now();
		console.log(timeConverter(now));
		console.log(now);
        return instancee.readCertificateIDs("0x00201010",i,i+1).then(function(result) {
        console.log("Transaction A:", result[1][0]);
		//console.log("Transaction B:", result);
		//console.log("Transaction C:", result);
		t=Math.floor(new Date().getTime()/1000)
		console.log('Iteration '+t)
		console.log("Running Transaction");
        console.log("Finished!");
        done();
		
	    return instancee.getCertificate("0x00201010",result[1][0]).then(function(result2) {
		console.log("Transaction A:", result2);
		//console.log(t)
		
		return instancee.getCertificateUserKeyMessage("0x00201010",result[1][0]).then(function(result3) {
		console.log("Transaction A:", result3);
		
		let tobesaved="CertReading,"+t+","+i+","+result[0]+","+result2+","+result3+"\n";
		fs.appendFile('Data.txt', tobesaved, (err) => {  
    // throws an error, you could also catch it here
    if (err) throw err;

    // success case, the file was saved
    console.log('fakeInsert Data saved!');
});

    }).catch(function(e) {
        console.log(e);
        done();
    });
	})})});
	
	
  }
  console.log("Finished")

	}
