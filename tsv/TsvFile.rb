# Read a TSV (tab-separated values) file line by line
# - very crude, doesn't take into account any quoting, escapes etc..
# - it also assumes the first line is for column headers

require 'json'

class TsvFile
  attr_accessor :filename
  
  def initialize filename
    @filename = filename
  end
  
  def each_line &block
    file = File.new(filename)
    headers = file.gets.chomp.split("\t")
    
    file.each do |line|      
      yield line_to_item(line, headers)
    end
  end
  
  def line_to_item line, headers
    item = {}
    entries = line.chomp.split("\t")
    (0..entries.length()-1).each do |i|
      entry = entries[i]
      # type conversion for numbers:
      if entry.match(/\A\d+\Z/) and !entry.start_with?('0') then
        # horribly crude way of checking for large integer
        entry = entry.to_i unless entry.length > 9
      end

      item[headers[i]] = entry unless entry == ""
    end
    
    item
  end
  
  def to_json
    each_line { |item| puts JSON.pretty_generate(item) }
  end

end
