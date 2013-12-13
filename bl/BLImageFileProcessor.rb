# processes a directory full of British Library Image metadata files

require_relative 'BLImageTsvFile'

class BLImageFileProcessor
  attr_accessor :processor
  
  def initialize processor
    @processor = processor
  end
  
  def process data_dir
    Dir.foreach(data_dir) do |file|
      # Currently unknown_plates.tsv is missing the header line, which is really
      # annoying.. all the other files have one.
      if file.end_with?('.tsv') and file != 'unknown_plates.tsv' then
        puts "Processing #{file}...\n"
        tsv = BLImageTsvFile.new(data_dir + file)
        @processor.load(tsv)
      end
    end
    
    process_unknown_plates(data_dir)
  end
  
  def process_unknown_plates data_dir
    # we have to do unknown_plates.tsv separately for now
    puts "Processing unknown_plates.tsv with added headers...\n"
    
    # use the header from unknown_small.tsv:
    header_line = File.new(data_dir + 'unknown_small.tsv').gets

    # write out a temporary file with the header, in the current dir:
    source_file = File.new(data_dir + 'unknown_plates.tsv')
    tmp_file = File.new('correctedunknown_plates.tsv', 'w')
    tmp_file.puts(header_line)
    source_file.each {|line| tmp_file.puts(line) }
    tmp_file.close()
    source_file.close()

    # now process the temp file:
    tsv = BLImageTsvFile.new('correctedunknown_plates.tsv')
    @processor.load(tsv)
    
    # clean up by deleting the tmp file:
    File.delete(tmp_file)
  end
end
