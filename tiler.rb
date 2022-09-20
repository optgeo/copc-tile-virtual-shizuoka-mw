require 'json'
require './zfxy.rb'
Z = 17

def cut(path, z, f, x, y)
  print "creating #{z}/#{f}/#{x}/#{y} from #{path}\n"
  bbox = zfxy2bbox(z, f, x, y)
  h0 = f2height(z, f)
  h1 = f2height(z, f + 1)
  max = `echo #{bbox[2]} #{bbox[3]} | cs2cs -f %.12f init=epsg:4326 +to +init=epsg:3857`.strip.split.map{|v| v.to_f}
  min = `echo #{bbox[0]} #{bbox[1]} | cs2cs -f %.12f init=epsg:4326 +to +init=epsg:3857`.strip.split.map{|v| v.to_f}
  bounds = 
    "([#{min[0]}, #{max[0]}], [#{min[1]}, #{max[1]}], [#{h0}, #{h1}])"
  filename = 
    "b/#{z}-#{f}-#{x}-#{y}-#{path.split('/')[-1]}"
  if File.exist?(filename)
    print "skip creating #{filename} because it is already there.\n"
    return
  end
  pipeline = [
    path,
    {
      :type => 'filters.reprojection',
      :in_srs => 'EPSG:6676',
      :out_srs => 'EPSG:3857'
    },
    {
      :type => 'filters.crop',
      :bounds => bounds
    },
    {
      :type => 'writers.las',
      :filename => filename
    }
  ]
  system "echo '#{JSON.dump(pipeline)}' | pdal pipeline -s"
  system "echo '#{JSON.pretty_generate(pipeline)}'"
end

#Dir.glob("a/*.las") {|path|
Dir.glob("az/*.laz") {|path|
  code = File.basename(path, '.laz')

  n = Dir.glob("b/*#{code}.laz").size
  if n > 0
    print "skip #{path} bacause there are #{n} files for #{code} in b.\n"
    next
  end

  json = JSON.parse(`pdal info #{path}`)
  bbox = json['stats']['bbox']['native']['bbox']
  max = `echo #{bbox['maxx']} #{bbox['maxy']} #{bbox['maxz']} | cs2cs -f %.12f +init=epsg:6676 +to +init=epsg:4326`.strip.split.map{|v| v.to_f}
  min = `echo #{bbox['minx']} #{bbox['miny']} #{bbox['minz']} | cs2cs -f %.12f +init=epsg:6676 +to +init=epsg:4326`.strip.split.map{|v| v.to_f}
  max_zfxy = point2zfxyArray(17, max[2], max[0], max[1])
  min_zfxy = point2zfxyArray(17, min[2], min[0], min[1])
  min_zfxy[1].upto(max_zfxy[1]) {|f|
    min_zfxy[2].upto(max_zfxy[2]) {|x|
      max_zfxy[3].upto(min_zfxy[3]) {|y|
        cut(path, Z, f, x, y)
      }
    }
  }
}

