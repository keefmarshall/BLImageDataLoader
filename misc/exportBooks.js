// db.volumes.find().sort({_id: 1})

var databaseURI = "localhost:27017/bldata";
var collections = ["books"];
var db = require("mongojs").connect(databaseURI, collections);

db.books.find().sort({"_id": 1}, function (err, books) {

	var fields = ["title", "first_author", "date", "pubplace", "publisher", "BL_DLS_ID", "ARK_id_of_book"];
	
    // Now we want to output a CSV file:
    console.log("book_identifier\t" + fields.join("\t"));
    for (var i = 0; i < books.length; i++)
    {
    	var line = [];
    	line.push(books[i]._id);

    	for(var j = 0; j < fields.length; j++)
    	{
    		line.push(books[i][fields[j]]);
    	}
    	
    	console.log(line.join("\t"));
    }
    
    process.exit();
});
