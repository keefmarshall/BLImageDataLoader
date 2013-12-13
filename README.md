BLImageDataLoader
=================

Scripts for managing the British Library image data

See: `https://github.com/BL-Labs/imagedirectory`

I'm new to Ruby - comments on coding style are welcome.

Loaders are currently supplied for:

- [MongoDB](#mongodb)
- [Elasticsearch](#elasticsearch)

<a name='mongodb'></a>
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

<a name='elasticsearch'></a>
ElasticLoader.rb
----------------

Ruby script for loading data into Elasticsearch

You'll need a local installation of Elasticsearch - currently doesn't support pointing
at a remote.

You'll need the elasticsearch driver for Ruby:

    gem install elasticsearch
    
To run the script, you need to pass in the directory containing the tsv files:

    ruby ElasticLoader.rb <path_to_tsv_files>

### Metrics:
- It takes a lot longer to run than the MongoDB one
- This is a lot of data, you might need to boost your elasticsearch heap (I did!) - if 
you get a timeout error, this is likely to be the problem.

