// Load the book metadata into MongoDB from book_metadata.json

var databaseURI = "localhost:27017/bldata";
var collections = ["bookmeta"];
var db = require("mongojs").connect(databaseURI, collections);

var fs = require('fs');
var file = '../../../data/bldata/imagedirectory/book_metadata.json';

var bookdata;
var waitingCount = 0;
fs.readFile(file, 'utf8', function (err, data) {
	if (err) {
		console.log('Error: ' + err);
		return;
	}
	 
	bookdata = JSON.parse(data);
	for (var i = 0; i < bookdata.length; i++) {
		var meta = bookdata[i];
		meta._id = meta.identifier;
		// add to Mongo:
		waitingCount++;
		db.bookmeta.update({"_id" : meta._id}, meta, {"upsert" : true}, function() { waitingCount--;});
	}
	
	// give save thread a chance to finish by waiting a second
	console.log("Waiting to finish..");
	waitForFinish();
});

function waitForFinish() {
	setTimeout((function() {
		console.log(waitingCount);
		if (waitingCount <= 0) {
			process.exit();
		} else {
			waitForFinish();
		}
	}), 1000);
}
