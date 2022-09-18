task :a do
  sh <<-EOS
curl -o tmp/list.txt \
https://gic-shizuoka.s3.ap-northeast-1.amazonaws.com/2022/p/LP/etc/LP_MeshList.txt
  EOS
  File.foreach('tmp/list.txt') {|l|
    code = l.strip
    if File.exist?("a/#{code}.las") or File.exist?("az/#{code}.laz")
      print "skip #{code} bacause it is already there.\n"
    else
      url = "https://gic-shizuoka.s3.ap-northeast-1.amazonaws.com/" + 
        "2022/p/LP/LAS/#{code}.zip"
      sh <<-EOS
curl -o tmp/#{code}.zip #{url}
unzip -d tmp tmp/#{code}.zip
rm tmp/#{code}.zip
mv tmp/#{code}.las a
      EOS
    end
  } 
end

task :az do
  require 'json'
  Dir.glob('a/*.las') {|path|
    code = File.basename(path, '.las')
    dst_path = "az/#{code}.laz"
    pipeline = [
      path,
      {
        :type => 'writers.las',
        :filename => dst_path
      }
    ]
    print "#{JSON.pretty_generate(pipeline)}\n"
    system "echo '#{JSON.dump(pipeline)}' | pdal pipeline -s"
    src_size = File.size(path)
    dst_size = File.size(dst_path)
    print "#{(100.0 * (src_size - dst_size) / src_size).round}% reduction.\n"
    system "rm #{path}"
  }
end

task :b do
  sh "ruby tiler.rb"
end

task :c do
  sh "ruby merger.rb"
end

task :frames do
  sh "ruby frames.rb > frames.geojsons"
  sh "ogr2ogr -f FlatGeobuf docs/frames.fgb frames.geojsons"
end

task :host do
  sh "budo -d docs"
end

