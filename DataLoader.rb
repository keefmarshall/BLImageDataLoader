# playing with British Library image metadata
# - data from their github repo here: 
# https://github.com/BL-Labs/imagedirectory
#
# This script loads all the image metadata into MongoDB.
#
# You'll need a MongoDB instance running somewhere
#
# You'll need the MongoDB driver for Ruby:
#    gem install mongo
# optionally for performance: 
#    gem install bson_ext 
#
# You'll need to tweak the settings at the bottom of the file to match your
# environment - mongo settings, image directory etc..
#
# Metrics:
# It takes about 6 minutes to run on my core i7 iMac (2009)
# it gets slower towards the end because the files are bigger
# The MongoDB database ends up around 2Gb in size so make sure you have space
#
# Author: Keith Marshall
# Date: 2013-12-13


Encoding.default_internal = 'utf-8'

require 'json'
require 'mongo'
require 'pathname'

include Mongo

class TsvFile
  attr_accessor :filename
  
  def initialize filename
    @filename = filename
  end
  
  def eachLine &block
    file = File.new(filename)
    type = extractTypeFromFilename
    headers = file.gets.chomp.split("\t")
    
    file.each do |row|
      entries = row.chomp.split("\t")

      item = { 'type' => type }
      (0..entries.length()-1).each do |i|
        item[headers[i]] = entries[i]
      end
      
      yield item
    end
  end
  
  # this bit is bl_data specific! remove to make this class generic
  def extractTypeFromFilename
    basename = File.basename(filename, File.extname(filename))
    basename.split('_')[1]
  end

end

# test class, just outputs JSON objects
class TsvToJson
  def initialize filename
    tsv = TsvFile.new(filename)
    tsv.eachLine { |item| puts JSON.pretty_generate(item) }    
  end
end

# take a TSV file, load each line into an item, load each item into Mongo
class TsvToMongo
  def initialize filename, collection
    tsv = TsvFile.new(filename)
    tsv.eachLine do |item| 
      item['_id'] = item['flickr_id']
      # the "true' makes this an upsert, will insert if not there
      collection.update({ '_id' => item['_id']}, item, {:upsert => true })
    end    
  end
end



mongohost = 'localhost'
mongoport = '27017'
bl_db = 'bldata'
image_coll = 'images'

db = MongoClient.new(mongohost, mongoport).db(bl_db)
images = db[image_coll]

data_dir = '/Users/keithm/Documents/workspace/bldata/imagedirectory/'

test_filename = data_dir + '1798_plates.tsv'
  
#TsvToJson.new(test_filename)
#TsvToMongo.new(test_filename, images)

Dir.foreach(data_dir) do |file|
  # OK, currently unknown_plates.tsv is missing the header line, which is really
  # annoying.. all the other files have one.
  if file.end_with?('.tsv') and file != 'unknown_plates.tsv' then
    puts "Processing #{file}...\n"
    TsvToMongo.new(data_dir + file, images)
  end
end

# we have to do unknown_plates.tsv separately for now
# write out a temporary file with the header, in the current dir:
# use the header from our test file:
header_line = File.new(test_filename).gets
source_file = File.new(data_dir + 'unknown_plates.tsv')
tmp_file = File.new('correctedunknown_plates.tsv', 'w')
tmp_file.puts(header_line)
source_file.each {|line| tmp_file.puts(line) }
tmp_file.close()
source_file.close()
TsvToMongo.new('correctedunknown_plates.tsv', images)
# clean up by deleting the tmp file:
File.delete(tmp_file)
