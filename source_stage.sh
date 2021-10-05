#!/bin/bash
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