require 'json'
require './zfxy.rb'
Z = 17

Dir.glob("a/*.las") {|path|
  json = JSON.parse(`pdal info #{path}`)
  bbox = json['stats']['bbox']['native']['bbox']
  max = `echo #{bbox['maxx']} #{bbox['maxy']} #{bbox['maxz']} | cs2cs -f %.12f +init=epsg:6676 +to +init=epsg:4326`.strip.split.map{|v| v.to_f}
  min = `echo #{bbox['minx']} #{bbox['miny']} #{bbox['minz']} | cs2cs -f %.12f +init=epsg:6676 +to +init=epsg:4326`.strip.split.map{|v| v.to_f}
  max_zfxy = point2zfxyArray(17, max[2], max[0], max[1])
  min_zfxy = point2zfxyArray(17, max[2], max[0], max[1])
  p max, max_zfxy, min, min_zfxy
}

