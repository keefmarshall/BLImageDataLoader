# processes a directory full of British Library Image metadata files

require_relative 'BLImageTsvFile'

class BLImageFileProcessor
  attr_accessor :processor
  
  def initialize processor
    @processor = processor
  end
  
  def process data_dir
    data_dir = (data_dir + '/') if !data_dir.end_with?('/')
    Dir.foreach(data_dir) do |file|
    if file.end_with?('_plates.tsv') or file.end_with?('_small.tsv') or file.end_with?('_medium.tsv') then
        puts "Processing #{file}...\n"
        tsv = BLImageTsvFile.new(data_dir + file)
        @processor.load(tsv)
      end
    end
  end
  
end
