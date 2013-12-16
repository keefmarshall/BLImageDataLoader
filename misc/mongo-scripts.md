MongoDB Scripts for British Library image data
==============================================

These are scripts to run inside the mongo command line (or similar client). They
assume you've previously imported the data into Mongo using the MongoLoader.rb script.

To get into the client and start using the database:

    mongo
    use bldata
 

Pixel Area
----------

Create 'areas' collection with the pixel areas of each image:

    db.areas.insert(db.images.find().map(function(image) { return {"_id": image._id, "area": image.flickr_original_height * image.flickr_original_width}}))

To do sort operations on this collection you'll need to add an index:

    db.areas.ensureIndex({'area':1})
    
List the biggest images:

    db.areas.find().sort({'area': -1})
    
Return the metadata for the 5 biggest images:

    db.areas.find().sort({'area': -1}).limit(5).map(function(area) { return db.images.findOne({'_id': area._id}) })

If you want just a few fields, e.g. just title, in the above query, do this:

    db.areas.find().sort({'area': -1}).limit(5).map(function(area) { return db.images.findOne({'_id': area._id}, {'title':1}) })
    
 To switch to the smallest images, use '1' instead of '-1' in the sort:
 
     db.areas.find().sort({'area': 1}).limit(5).map(function(area) { return db.images.findOne({'_id': area._id}, {'title':1}) })
 
 Place of Publication
 --------------------
 
 I created a collection with the unique publication place entries, along with totals:
 
    db.pubplaces.insert(db.images.group({ key: {"pubplace": 1}, reduce: function(curr, result){ result.total++ }, initial: { total: 0 } }))
    
 .. unfortunately this data is very inconsistent, and in some places needs a lot of work.
 Still, if we take the most common places it gives us something to work with, so:
 
    db.pubplaces.find().sort({"total":-1}).limit(20)
    
.. gives us the top 20 publication places (one of which is "null", or unknown)
