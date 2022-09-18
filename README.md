# copc-tile-virtual-shizuoka-mw
PoC: COPC Tile (z=17) of virtual-shizuoka-mw

This repository contains the codes only because the data size is huge. 

# stages
## stage A
- plain downloaded files from [virtual-shizuoka-mw](https://www.geospatial.jp/ckan/dataset/virtual-shizuoka-mw/resource/1879dffe-f449-42e5-8371-2273300fa8b8).
- file url template is `https://gic-shizuoka.s3.ap-northeast-1.amazonaws.com/2022/p/LP/LAS/${code}.zip`
- `${code}` list is on https://gic-shizuoka.s3.ap-northeast-1.amazonaws.com/2022/p/LP/etc/LP_MeshList.txt.
- CRS: 平面直角座標系VIII = EPSG:6676 = 6668 + 8 :-)

## stage B
- z=17 tiled LAS files from each stage A file
- EPSG: 3857

## stage C
- z=17 tiled COPC files from stage B files, merged by tile numbers.
- EPSG: 3857
- GeoJSON text sequence should be produced, too.

# the site
- HTML hosted here on GitHub pages.
- Tiles hosted on x.optgeo.org.
- 
