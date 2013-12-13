# Script for loading British Library TSV files into MongoDB
#
# Pass in the directory path to the image metadata files as a command line parameter
#
# e.g. ruby MongoLoader.rb ../bldata/imagedirectory

Encoding.default_internal = 'UTF-8'

require_relative 'tsv/TsvToMongo'
require_relative 'bl/BLImageFileProcessor'

# configuration goes here - change these to match your local system:
mongo_opts =  {
  :host => 'localhost',
  :port => 27017,
  :db => 'bldata',
  :coll => 'images'
}

# data directory is passed in as a command line argument
if ARGV[0] then
  data_dir = ARGV[0]
else
  abort "You must specify the data directory when running this script."
end

 # set up our mongo importer
importer = TsvToMongo.new('flickr_id', mongo_opts)  

# OK, off we go..
BLImageFileProcessor.new(importer).process(data_dir)
