task :a do
  sh <<-EOS
curl -o tmp/list.txt \
https://gic-shizuoka.s3.ap-northeast-1.amazonaws.com/2022/p/LP/etc/LP_MeshList.txt
  EOS
  File.foreach('tmp/list.txt') {|l|
    code = l.strip
    if File.exist?("a/#{code}.las")
      print "skip #{code} bacause it is already there.\n"
    else
      url = "https://gic-shizuoka.s3.ap-northeast-1.amazonaws.com/" + 
        "2022/p/LP/LAS/#{code}.zip"
      sh <<-EOS
curl -o tmp/#{code}.zip #{url}
unzip -d a tmp/#{code}.zip
rm tmp/#{code}.zip
      EOS
    end
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

