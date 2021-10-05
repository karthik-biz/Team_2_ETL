#!/bin/bash
csv_files=`ls -1 *.csv`
echo "$csv_files"
for filename in $csv_files
do
y=${filename%.csv}
echo "$y"
done
