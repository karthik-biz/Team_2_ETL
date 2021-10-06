
#!/bin/bash
#crone tab * * * * * /home/folder/gfg-code.sh
set -x
db_name="ACTIANS_DWSTAGE"
db_user="karthik"
db_password="101332649"
source_folder="/home/ec2-user/csv/source"
cd $source_folder
if [ ! -d /home/ec2-user/csv/processing ]; then
  mkdir -p /home/ec2-user/csv/processing;
  chmod 777 /home/ec2-user/csv/processing;
fi

if [ ! -d /home/ec2-user/csv/processed ]; then
  mkdir -p /home/ec2-user/csv/processed;
  chmod 777 /home/ec2-user/csv/processed;
fi

if [ ! -d /home/ec2-user/csv/processed/batch.log]; then
  mkdir -p /home/ec2-user/csv/processed/batch.log;
  chmod 777 /home/ec2-user/csv/processing/batch.log;
fi
csv_files=`ls -1 *.csv`
#Presently working in same directory so remember to  declare variable and update in loop later
for csv_file in ${_csv_files[@]}
do
if
ls -1qA /home/ec2-user/csv/source | grep -q .
then
! echo Files are present. Process beginning....
else
echo No files present. Rescheduling
break
fi
echo "Process has started for $csv_file at" %DATE% %TIME% >> /home/ec2-user/csv/processing/batch.log
table_name=`echo "$csv_file" | awk -F'[_.]' '{print $1}'`
store_num=`echo "$csv_file" | awk -F'[_.]' '{print $3}'`
mysql -u karthik -p101332649 << EOF
SET GLOBAL LOCAL_INFILE=1;
LOAD DATA LOCAL INFILE
'$csv_file'
INTO TABLE ACTIANS_DWSTAGE.'$table_name'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

EOF
mv /home/e2-user/csv/processing/'$csv_file' /home/ec2-user/csv/processed
echo "Process has ended for $csv_file at" %DATE% %TIME% >> /home/ec2-user/csv/processing/batch.log
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
echo "Current Time : $current_time">>/home/ec2-user/csv/processing/batch.log
 
new_fileName=$csv_file.$current_time
echo "New FileName: " "$new_fileName"
 
$(mv /home/ec2-user/csv/processing/$csv_file /home/ec2-user/csv/processed/$new_filename)

done
exit
