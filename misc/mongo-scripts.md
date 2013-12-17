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

Volumes and Books
-----------------

There's a lot of de-normalised data in the original files, as each image comes
complete with all the relevant book/volume information. We can extract this - there
are 31183 unique book identifiers, but we should also be aware that each book can have
more than one volume, and potentially volumes might have different titles etc.. so we
aggregate the book_identifier and the volume field. Using this method we get 38546 
unique volumes in the data set. 

To create a new collection of volumes, we do this in the mongo shell:

    db.volumes.insert(db.images.aggregate({$group: { _id: {_id: "$book_identifier", volume: "$volume"}, title: {$min: "$title"}, first_author: {$min: "$first_author"}, date: {$min: "$date"}, pubplace: {$min: "$pubplace"}, publisher: {$min: "$publisher"}, BL_DLS_ID: {$min: "$BL_DLS_ID"}, ARK_id_of_book: {$min: "$ARK_id_of_book"}}}).result)

[NB: there is a contributed file books_list.csv in the data set which is A. not a CSV 
(it looks tab-delimited, but with pipes in some fields?) and B. also has 49455 entries -
I don't know how this list was created and how they defined a unique book - it's possible
this data comes from an external source and has books with no images?]

If you really don't care about volumes and just want unique books, that's easy enough:

    db.books.insert(db.images.aggregate({$group: { _id: "$book_identifier", title: {$min: "$title"}, first_author: {$min: "$first_author"}, date: {$min: "$date"}, pubplace: {$min: "$pubplace"}, publisher: {$min: "$publisher"}, BL_DLS_ID: {$min: "$BL_DLS_ID"}, ARK_id_of_book: {$min: "$ARK_id_of_book"}}}).result)


