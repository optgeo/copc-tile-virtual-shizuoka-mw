require 'json'

def merge(zfxy, list)
  p zfxy
  p list
  pipeline = list
  pipeline.map! {|v| "b/#{zfxy}-#{v}.laz" }
  pipeline << { :type => 'filters.merge' }
  pipeline << { :type => 'writers.copc',
    :filename => "c/#{zfxy}.copc.laz" }
  print "#{JSON.pretty_generate(pipeline)}\n"
  system "echo '#{JSON.dump(pipeline)}' | pdal pipeline -s"
end

hash = Hash.new {|h, k| h[k] = []}
Dir.glob("b/*.laz") {|path|
  r = File.basename(path, '.laz').split('-')
  hash[r[0..3].join('-')].push(r[4])
}
hash.each {|k, v| merge(k, v)}

