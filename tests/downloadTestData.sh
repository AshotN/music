#!/usr/bin/env bash
# this downloads test data from jamendo that is then moved to the data folder
# and then caan be scanned by the ownCloud filescanner

urls="https://storage-new.newjamendo.com/download/a131278/mp32/
https://storage-new.newjamendo.com/download/a130324/mp32/
https://storage-new.newjamendo.com/download/a129252/mp32/
https://storage-new.newjamendo.com/download/a126850/mp32/
https://storage-new.newjamendo.com/download/a123905/mp32/
https://storage-new.newjamendo.com/download/a123663/mp32/
https://storage-new.newjamendo.com/download/a123543/mp32/
https://storage-new.newjamendo.com/download/a123495/mp32/
https://storage-new.newjamendo.com/download/a49216/mp32/
https://storage-new.newjamendo.com/download/a3311/mp32/"

if [ ! -d /tmp/downloadedData ];
then
    mkdir -p /tmp/downloadedData
fi

cd /tmp/downloadedData

for url in $urls
do
    name=`echo $url | cut -d "/" -f 5`
    if [ ! -d "$name" ];
    then
        echo "Downloading $name ..."
        wget $url -q --no-check-certificate -O archive.zip
        if [ $? -ne 0 ];
        then
            sleep 5
            wget $url --no-check-certificate -O archive.zip
            if [ $? -ne 0 ];
            then
                sleep 5
                wget $url --no-check-certificate -O archive.zip
                if [ $? -ne 0 ];
                then
                    exit 1
                fi
            fi
        fi
        unzip archive.zip -d $name
        rm archive.zip
    else
        echo "$name is already available"
    fi
done

# go back to the old folder
cd -

mkdir -p $1/files/
cp -r /tmp/downloadedData $1/files/music
