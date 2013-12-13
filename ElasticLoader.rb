# Script for loading British Library TSV files into Elasticsearch
#
# Pass in the directory path to the image metadata files as a command line parameter
#
# e.g. ruby ElasticLoader.rb ../bldata/imagedirectory

Encoding.default_internal = 'UTF-8'

require_relative 'tsv/TsvToElasticSearch'
require_relative 'bl/BLImageFileProcessor'

# data directory is passed in as a command line argument
if ARGV[0] then
  data_dir = ARGV[0]
else
  abort "You must specify the data directory when running this script."
end

 # set up our importer
importer = TsvToElasticSearch.new('flickr_id', 'bldata', 'image')  

# OK, off we go..
BLImageFileProcessor.new(importer).process(data_dir)
