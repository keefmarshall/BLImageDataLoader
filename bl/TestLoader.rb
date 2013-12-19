# quick visual inspection test - output a single file as JSON

Encoding.default_internal = 'UTF-8'

require_relative 'BLImageFileProcessor'

# specify file to test as a command line argument
if ARGV[0] then
  data_file = ARGV[0]
else
  abort "You must specify the data file when running this script."
end

BLImageTsvFile.new(data_file).to_json()
