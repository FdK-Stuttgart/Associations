#!/bin/bash

# dosm=/tmp/Documents
dosm=~/Documents
dtlm=$dosm/tilemill
# created by unzip
dmapbox=$dosm/mapbox-osm-bright-f1c8780
dshp=$dmapbox/shp
# prj=OSMBright
prj=fdk

sudo apt install --yes \
    postgresql \
    postgresql-14-postgis-3 \
    build-essential \
    protobuf-compiler \
    libprotobuf-dev \
    libtokyocabinet-dev \
    python3 \
    python3-dev \
    python2 \
    libgeos-c1v5 \
    osm2pgsql \
    npm

# sudo apt install --yes \
#     font-manager \
#     fonts-khmeros \
#     fonts-arundina \
#     fonts-gargi \
#     fonts-unifont \
#     fonts-taml-tscu \
#     ttf-indic-fonts-core \
#     unifont \
#     ubuntustudio-font-meta \
#     fonts-indic \
#     fonts-knda \
#     lvm2           # Linux Logical Volume Manager

wzip () {
    # $1 url $2 dest dir
    test ! -d $2 && mkdir -p $2
    bn=$(basename $1)
    set -x  # Print commands and their arguments as they are executed.
    wget -q $1 -P $2 && \
    unzip $2/$bn -d $2 || \
    $(echo "[ERR] wzip failed" && return 1)
    { retval="$?"; set +x; } 2>/dev/null
}

wosm () {
    wzip $1 $dosm
}

wshp () {
    wzip $1 $dshp
}

wosm https://github.com/mapbox/osm-bright/zipball/master
wzip https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places.zip \
     $dshp/ne_10m_populated_places
wshp https://osmdata.openstreetmap.de/download/simplified-land-polygons-complete-3857.zip
wshp https://osmdata.openstreetmap.de/download/land-polygons-split-3857.zip

sudo cp /etc/postgresql/14/main/pg_hba.conf{,.backup}
sudo vim /etc/postgresql/14/main/pg_hba.conf
# Edit pg_hba.conf according to
# https://tilemill-project.github.io/tilemill/docs/guides/osm-bright-ubuntu-quickstart/
sudo systemctl restart postgresql

# pbfFile=berlin.osm.pbf
# pbfFile=stuttgart-regbez-latest.osm.pbf
pbfFile=germany-latest.osm.pbf

wget -q http://download.geofabrik.de/europe/$pbfFile -P $dmapbox

set -x && \
psql             -U postgres -c "drop extension if exists PostGIS cascade;" && \
psql             -U postgres -c "drop database if exists osm;" && \
psql             -U postgres -c "create database osm;" && \
psql      -d osm -U postgres -c "CREATE EXTENSION postgis;" && \
psql      -d osm -U postgres -f /usr/share/postgresql/14/contrib/postgis-3.2/postgis.sql && \
psql      -d osm -U postgres -f /usr/share/postgresql/14/contrib/postgis-3.2/spatial_ref_sys.sql && \
osm2pgsql -d osm -U postgres -c -G $dmapbox && \
psql      -d osm -U postgres -c "SELECT ST_SRID("way") AS srid FROM planet_osm_polygon WHERE "way" IS NOT NULL LIMIT 1;" || \
echo "[ERR] Postgres setup failed"

cp $dshp/configure.py.sample $dshp/configure.py
# Edit configure.py according to Step 3
# https://tilemill-project.github.io/tilemill/docs/guides/osm-bright-ubuntu-quickstart/
vim $dshp/configure.py
# sed/config["postgis"]["user"]     = ""/config["postgis"]["user"]     = "postgres"/

# install TileMill
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && \
git clone https://github.com/tilemill-project/tilemill.git $dtlm && \
cd $dtlm && \
nvm install lts/carbon && \
# nvm use v8.15.0 && \
npm install && \
./tilemill.sh || \
echo "[ERR] TileMill installation failed"

# cd $dtlm && \
# rm -rf $dtlm/node_modules && \
# nvm install v8.15.0 && \
# nvm use v8.15.0 && \
# npm install && \
# ./tilemill.sh

# export works only with node v8.15.0 !!!
# maxzoom=16    #  ? minutes, total size 12GB,  total #tiles 1.3M
# maxzoom=12    # 24 minutes, total size 387MB, total #tiles 20k
maxzoom=9       #  4 minutes, total size  13MB, total #tiles 341
cd $dtlm && \
nvm use v8.15.0 && \
beg=$(date) && \
time \
./index.js export $prj ~/Documents/MapBox/export/$prj.mbtiles \
    --metatile=2 --scale=1 \
    --minzoom=6 --maxzoom=$maxzoom \
    --bbox=5.8632,47.2650,15.0485,55.1050
echo $beg
date
    # --bbox=-4.7671,-4.0256,5.0659,3.6939  \
    # --bbox=5.8228,47.2457,15.0732,53.8298

# ./index.js export --help

# initialize OSM Bright project and run TileMill
nvm use v8.15.0 && \
cd $dmapbox && ./make.py && \
cd $dtlm && \
npm start

# http://localhost:20009/

# https://github.com/maptiler/tileserver-gl
#
# Error: "libicui18n.so.66: cannot open shared object file" when try to run tileserver-gl on Ubuntu 22.04.3 LTS
# https://github.com/maptiler/tileserver-gl/issues/973

sudo apt install --yes libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev build-essential g++ xvfb libgles2-mesa-dev libgbm-dev libxxf86vm-dev
nvm install v18.17.1
nvm use v18.17.1
npm install -g tileserver-gl

vim /home/bost/Documents/index.html

nvm use v18.17.1 && \
tileserver-gl-light --mbtiles ~/Documents/MapBox/export/$prj.mbtiles

http://localhost:8080/tile/OSMBright/{z}/{x}/{y}.png?updated=1694680731000&metatile=2&scale=1/data/OSMBright/{z}/{x}/{y}.png
# /z/ is the zoom level, /x/ is the longitude and is used as a directory name. Then within that directory there's y.png, which has the y coordinates as the filename

# map center (Hessen): 6 - zoom level
# 10.3052,51.2619,6
http://localhost:8080/data/OSMBright/7/67/43.png
