#!/bin/sh
ts=`date +%Y-%m-%d_%Hh%M`
DIR=/root/dolibarr-backup
bd=$DIR/dolibarr-$ts
PASSWORD={{ backup_password }}

rm -rf $bd
mkdir -p $bd
mysqldump dolibarr > $bd/dump.sql
cd /var/www/dolibarr-{{ dolibarr_version }}
cp htdocs/conf/conf.php $bd
tar cf $bd/documents.tar documents
cd $DIR
tar c dolibarr-$ts | gpg -c --passphrase $PASSWORD --cipher-algo AES256 > $bd.tar.gpg
rm -rf $bd

echo NAME=`date +dolibarr_%Y-%m-%d_%Hh%M` > $DIR/.pca
echo DELETEINDAY=90 >> $DIR/.pca
scp -4 -i /root/.ssh/backup_key $bd.tar.gpg $DIR/.pca {{ backup_destination }}
rm $DIR/.pca $bd.tar.gpg
