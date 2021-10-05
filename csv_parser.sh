#!/bin/bash
set -x
db_name="ACTIANS_DWSTAGE"
db_user="karthik"
db_password="101332649"
source_folder="/mnt/c/csv"
cd $source_folder
if [ ! -d /mnt/c/csv/processing ]; then
  mkdir -p /mnt/c/csv/processing;
  chmod 777 /mnt/c/csv/processing;
fi

if [ ! -d /mnt/c/csv/processed ]; then
  mkdir -p /mnt/c/csv/processed;
  chmod 777 /mnt/c/csv/processed;
fi

if [ ! -d /mnt/c/csv/processed/batch.log]; then
  mkdir -p /mnt/c/csv/processed/batch.log;
  chmod 777 /mnt/c/csv/processing/batch.log;
fi

#Presently working in same directory so remember to  declare variable and update in loop later
for folder in  */; do
if [ -d "$folder" ]; then
        # Will not run if no directories are available
        echo "$folder is empty"
	continue
    fi
echo "Process has started for $folder at" %DATE% %TIME% >> /mnt/c/csv/processing/batch.log
if [ ! -d /mnt/c/csv/processing/"$folder" ]; then
  mkdir -p /mnt/c/csv/processing/"$folder";
fi
mysql -u karthik -p101332649 << EOF
SET GLOBAL LOCAL_INFILE=1;
LOAD DATA LOCAL INFILE
'offices.csv'
INTO TABLE ACTIANS_DWSTAGE.offices
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE
'employees.csv'
INTO TABLE ACTIANS_DWSTAGE.employees
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE
'orderdetails.csv'
INTO TABLE ACTIANS_DWSTAGE.orderdetails
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE
'orders.csv'
INTO TABLE ACTIANS_DWSTAGE.orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
LOAD DATA LOCAL INFILE
'payments.csv'
INTO TABLE ACTIANS_DWSTAGE.payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE
'productlines.csv'
INTO TABLE ACTIANS_DWSTAGE.productlines
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
EOF
mv /mnt/c/csv/processing/"$folder" /mnt/c/csv/processed
echo "Process has ended for $folder at" %DATE% %TIME% >> /mnt/c/csv/processing/batch.log

done
exit
