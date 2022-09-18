require './zfxy.rb'
require 'json'

def to_geojsonseq(list)
  list.each {|zfxy, v|
    f = zfxy2geojson(*zfxy)
    f[:tippecanoe] = {
      :layer => 'frames',
    }
    print "\x1e#{JSON.dump(f)}\n"
  }
end

list = {}
Dir.glob('c/*.copc.laz') {|path|
  zfxy = path.split('/')[1].split('-')[0..3].map{|v| v.to_i}
  list[zfxy] = 1
}
to_geojsonseq(list)
