# Loads a TSV file into a MongoDB collection
# You need to specify the ID field used for Mongo's _id param at construction
#
# Sample mongo_opts:
#
#  mongo_opts =  {
#    :host => 'localhost',
#    :port => 27017,
#    :db => 'bldata',
#    :coll => 'images'
#  }

require 'mongo'

include Mongo

class TsvToMongo
  attr_accessor :id_field, :db, :collection
  
  def initialize id_field, mongo_opts
    @id_field = id_field
    @db = MongoClient.new(mongo_opts[:host], mongo_opts[:port]).db(mongo_opts[:db])
    @collection = @db[mongo_opts[:coll]]
  end
  
  def load tsv
    tsv.each_line do |item| 
      
      # add ID field
      item['_id'] = item[@id_field]
        
      # this 'update' will insert if not there
      @collection.update({ '_id' => item['_id']}, item, {:upsert => true })
    end    
  end
end
