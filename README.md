BLImageDataLoader
=================

Scripts for managing the British Library image data

See: `https://github.com/BL-Labs/imagedirectory`

I'm new to Ruby - comments on coding style are welcome.

Loaders are currently supplied for:

- [MongoDB](#mongodb)
- [Elasticsearch](#elasticsearch)

UPDATE: 15th Dec 2013:
-----------------

I've changed  the scripts to do some rudimentary typing, so most numbers (pubyear, sizes)
get loaded as integers rather than strings. This makes it possible to do range queries.

Unfortunately if you've already loaded the data into Elasticsearch this means
you'll have to delete your index and start again, because it sets the types automatically
and there's no way to change them once set.

If you used my default index settings you can do this as follows:

    curl -XDELETE http://localhost:9200/bldata

.. then re-run the loader.

Normally, re-running the loaders is non-invasive and should just apply any updates from
the source files - hopefully this is a once-off.


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
- It takes about 10 minutes to run on my core i7 iMac (2009) 
- it gets slower towards the end because the files are bigger
- The MongoDB database ends up around 6Gb in size, 
so make sure you have space (it was 2Gb before the FLickr image URLs were added)
- I ended up with 1019206 total items in the collection
- There are 31183 unique book identifiers

<a name='elasticsearch'></a>
ElasticLoader.rb
----------------

Ruby script for loading data into [Elasticsearch](http://www.elasticsearch.org/).

You'll need a local installation of Elasticsearch - currently doesn't support pointing
at a remote.

You'll need the elasticsearch driver for Ruby:

    gem install elasticsearch
    
To run the script, you need to pass in the directory containing the tsv files:

    ruby ElasticLoader.rb <path_to_tsv_files>

This creates an index 'bldata' and type/collection 'image'. For basic searching I suggest
installing the ['Browser' plugin](https://github.com/OlegKunitsyn/elasticsearch-browser).
If you do this you can search the index at this URL:

    http://localhost:9200/_plugin/browser/?database=bldata&table=image

### Metrics:
- It takes a lot longer to run than the MongoDB one - around 40 minutes on my Mac (the
load time didn't change when more fields were added to the source data)
- This is a lot of data, you might need to boost your elasticsearch heap (I did!) - if 
you get a timeout error, this is likely to be the problem.
- My Elasticsearch data directory for this content is about 800Mb in size


