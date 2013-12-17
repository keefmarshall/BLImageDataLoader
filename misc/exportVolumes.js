// db.volumes.find().sort({_id: 1})

var databaseURI = "localhost:27017/bldata";
var collections = ["volumes"];
var db = require("mongojs").connect(databaseURI, collections);

// Bizarrely this sorts volumes beginning with zero below those without. So
// you get e.g. 10, 11, 12, 01, 02, 03.. no idea why.  Cannot understand this.
// Don't know how to fix it, either.. not the end of the world, just really
// annoying. Adding in the volume field separately makes no difference.
db.volumes.find().sort({"_id": 1}, function (err, volumes) {

	var idfields = ["book_identifier", "volume"];
	var fields = ["title", "first_author", "date", "pubplace", "publisher", "BL_DLS_ID", "ARK_id_of_book"];
	
    // Now we want to output a CSV file:
    console.log(idfields.join("\t") + "\t" + fields.join("\t"));
    for (var i = 0; i < volumes.length; i++)
    {
    	var line = [];
    	line.push(volumes[i]._id._id);
    	line.push(volumes[i]._id.volume);

    	for(var j = 0; j < fields.length; j++)
    	{
    		line.push(volumes[i][fields[j]]);
    	}
    	
    	console.log(line.join("\t"));
    }
    
    process.exit();
});