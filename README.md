BLImageDataLoader
=================

Scripts for managing the British Library image data

See: `https://github.com/BL-Labs/imagedirectory`

I'm new to Ruby - comments on coding style are welcome.

MongoLoader.rb
--------------

Ruby script for loading data into MongoDB.

You'll need a MongoDB instance running somewhere

You'll need the MongoDB driver for Ruby:

    gem install mongo
    
optionally for performance: 

    gem install bson_ext 

You'll need to tweak the Mongo settings near the top of the file to match your
local environment.

To run the script, you need to pass in the directory containing the tsv files:

    ruby MongoLoader.rb <path_to_tsv_files>

### Metrics:
- It takes about 6 minutes to run on my core i7 iMac (2009)
- it gets slower towards the end because the files are bigger
- The MongoDB database ends up around 2Gb in size so make sure you have space
- I ended up with 1019206 total items in the collection
- There are 31183 unique book identifiers
