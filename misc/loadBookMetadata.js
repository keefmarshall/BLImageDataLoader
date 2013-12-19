// Load the book metadata into MongoDB from book_metadata.json

var databaseURI = "localhost:27017/bldata";
var collections = ["bookmeta"];
var db = require("mongojs").connect(databaseURI, collections);

var fs = require('fs');
var file = '../../../data/bldata/imagedirectory/book_metadata.json';

var bookdata;
fs.readFile(file, 'utf8', function (err, data) {
	if (err) {
		console.log('Error: ' + err);
		return;
	}
	 
	bookdata = JSON.parse(data);
	for (var id in bookdata) {
		var meta = bookdata[id];
		meta._id = id;
		// add to Mongo:
		db.bookmeta.update({"_id" : id}, meta, {"upsert" : true});
	}
});
