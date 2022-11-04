#file-name: postgres-backup.sh
#!/bin/bash

cd /home/this
date1=$(date +%Y%m%d-%H%M)
mkdir pg-backup
PGPASSWORD="$POSTGRES_PASSWORD" pg_dumpall -h postgres-postgresql -p 5432 -U postgres > pg-backup/postgres-db.sql
file_name="pg-backup-"$date1".tar.gz"

#Compressing backup file for upload
tar -zcvf $file_name pg-backup

filesize=$(stat -c %s $file_name)
mfs=10
if [[ "$filesize" -gt "$mfs" ]]; then
# Uploading to s3
aws s3 cp pg-backup-$date1.tar.gz $S3_BUCKET
fi
