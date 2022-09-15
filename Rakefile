task :a do
  sh <<-EOS
curl -o tmp/list.txt \
https://gic-shizuoka.s3.ap-northeast-1.amazonaws.com/2022/p/LP/etc/LP_MeshList.txt
  EOS
  File.foreach('tmp/list.txt') {|l|
    code = l.strip
    url = "https://gic-shizuoka.s3.ap-northeast-1.amazonaws.com/" + 
      "2022/p/LP/LAS/#{code}.zip"
    sh <<-EOS
curl -o tmp/#{code}.zip #{url}
unzip -d a tmp/#{code}.zip
rm tmp/#{code}.zip
    EOS
  } 
end

task :b do
  sh "ruby tiler.rb"
end

