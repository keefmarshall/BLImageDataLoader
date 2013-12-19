# Class specifically for reading British Library image metadata files
# see: https://github.com/BL-Labs/imagedirectory

require_relative '../tsv/TsvFile'

class BLImageTsvFile < TsvFile
  attr_accessor :type
  
  def initialize filename
    super
    @type = extract_type_from_filename
    @string_fields = ['flickr_id', 'volume', 'page', 'book_identifier']
  end
  
  # override super class
  def line_to_item line, headers
    item = super
    item["type"] = @type
    item
  end
  
  # this bit is bl_data specific
  def extract_type_from_filename
    basename = File.basename(filename, File.extname(filename))
    basename.split('_')[1]
  end

end
