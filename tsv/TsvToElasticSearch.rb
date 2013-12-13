# Loads a TSV file into an Elasticsearch index

require 'elasticsearch'


class TsvToElasticSearch
  attr_accessor :id_field, :client, :index, :type
  
  def initialize id_field, index, type
    @id_field = id_field
    @index = index
    @type = type
    @client = Elasticsearch::Client.new log: false
  end
  
  def load tsv
    tsv.each_line do |item|
      @client.index index: @index, type: @type, id: item[@id_field], body: item
    end
  end
  
end