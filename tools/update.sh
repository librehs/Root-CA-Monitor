#!/bin/bash

MONTH=$(date +%m)
YEAR=$(date +%Y)
LASTMONTH=$(date --date='-1 month' +%m)
LASTYEAR=$(date --date='-1 month' +%Y)

echo "Fetching certificates for ${YEAR}/${MONTH}"
mkdir -p data/${YEAR}
wget https://ccadb.my.salesforce-sites.com/mozilla/IncludedCACertificateReportCSVFormat -O data/${YEAR}/${YEAR}-${MONTH}-ca.csv
wget https://ccadb.my.salesforce-sites.com/mozilla/IncludedCACertificateReportPEMCSV -O data/${YEAR}/${YEAR}-${MONTH}-ca-withpem.csv
echo "Comparing difference from ${LASTYEAR}/${LASTMONTH} to ${YEAR}/${MONTH}"
LASTFILENAME="data/${LASTYEAR}/${LASTYEAR}-${LASTMONTH}-ca.csv"
if [ -f "$LASTFILENAME" ]
then
    diff $LASTFILENAME data/${YEAR}/${YEAR}-${MONTH}-ca.csv > data/${YEAR}/${YEAR}-${MONTH}-ca.diff
else
    echo "[WARN] File for last month $LASTFILENAME doesn't exist."
fi

echo "Pushing to git"
git add -A
git commit -m "Update for ${YEAR}/${MONTH}"
