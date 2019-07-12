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
  for (let i = 0; i < 100; i++) {
    SimpleStorage.deployed().then(function(instance) {
        var instancee=instance;
		now=Date.now();
		console.log(timeConverter(now));
		console.log(now);
        return instancee.fakeInsert(1);
    }).then(function(result) {
        //console.log("Transaction:", result.tx);
		//console.log("Transaction:", result);
		//console.log("Transaction:", result.receipt.gasUsed);
		t=Math.floor(new Date().getTime()/1000)
		//console.log('Iteration '+t)
		//console.log("Running Transaction");
        //console.log("Finished!");
        done();
		//console.log(t)
		//let tobesaved="fakeInsert,"+result.tx+","+t+","+result.receipt.gasUsed+"\n";
		//fs.appendFile('Data.txt', tobesaved, (err) => {  
    // throws an error, you could also catch it here
    //if (err) throw err;

    // success case, the file was saved
    //console.log('fakeInsert Data saved!');
//});

    }).catch(function(e) {
        console.log(e);
        done();
    });
};
	
	
  }
  console.log("Finished")

