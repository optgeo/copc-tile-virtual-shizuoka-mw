require 'json'
require './zfxy.rb'
Z = 17

def cut(path, z, f, x, y)
  print "creating #{z}/#{f}/#{x}/#{y} of #{path}\n"
end

Dir.glob("a/*.las") {|path|
  json = JSON.parse(`pdal info #{path}`)
  bbox = json['stats']['bbox']['native']['bbox']
  max = `echo #{bbox['maxx']} #{bbox['maxy']} #{bbox['maxz']} | cs2cs -f %.12f +init=epsg:6676 +to +init=epsg:4326`.strip.split.map{|v| v.to_f}
  min = `echo #{bbox['minx']} #{bbox['miny']} #{bbox['minz']} | cs2cs -f %.12f +init=epsg:6676 +to +init=epsg:4326`.strip.split.map{|v| v.to_f}
  max_zfxy = point2zfxyArray(17, max[2], max[0], max[1])
  min_zfxy = point2zfxyArray(17, min[2], min[0], min[1])
p min_zfxy, max_zfxy
  min_zfxy[1].upto(max_zfxy[1]) {|f|
    min_zfxy[2].upto(max_zfxy[2]) {|x|
      max_zfxy[3].upto(min_zfxy[3]) {|y|
        cut(path, Z, f, x, y)
      }
    }
  }
}

