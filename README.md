BLImageDataLoader
=================

Scripts for managing the British Library image data

See: `https://github.com/BL-Labs/imagedirectory`

DataLoader.rb
-------------

Ruby script for loading data into MongoDB.

You'll need a MongoDB instance running somewhere

You'll need the MongoDB driver for Ruby:

    gem install mongo
    
optionally for performance: 

    gem install bson_ext 

You'll need to tweak the settings at the bottom of the file to match your
environment - mongo settings, image directory etc..

### Metrics:
- It takes about 6 minutes to run on my core i7 iMac (2009)
- it gets slower towards the end because the files are bigger
- The MongoDB database ends up around 2Gb in size so make sure you have space
