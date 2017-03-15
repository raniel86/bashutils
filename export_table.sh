#!/bin/bash

sshUser=''
dbHost=''
dbUser=''
dbPass=''
dbName=''
dbTable=''
noSplit=0
maxRows=0
count=1
compress=0

# get command line arguments
for i in "$@"; do
	case $i in
		-s=*|--ssh-user=*)
			sshUser="${i#*=}"
			shift
		;;
		-h=*|--db-host=*)
			dbHost="${i#*=}"
			shift
		;;
		-u=*|--db-user=*)
			dbUser="${i#*=}"
			shift
		;;
		-p=*|--db-pass=*)
			dbPass="${i#*=}"
			shift
		;;
		-n=*|--db-name=*)
			dbName="${i#*=}"
			shift
		;;
		-t=*|--db-table=*)
			dbTable="${i#*=}"
			shift
		;;
		-m=*|--max-rows=*)
			maxRows="${i#*=}"
			shift
		;;
		--no-split)
			noSplit=1
			shift
		;;
		--compress)
			compress=1
			shift
		;;
		*)
			echo "Invalid argument $i"
			exit 1
		;;
	esac
done

# get values from prompt
if [ -z $sshUser ]; then
	echo -n "SSH user (relative to db host): "
	read sshUser
fi

if [ -z $dbHost ]; then
	echo -n "Database host: "
	read dbHost
fi

if [ -z $dbUser ]; then
	echo -n "Database user: "
	read dbUser
fi

if [ -z $dbPass ]; then
	echo -n "Database password: "
	read dbPass
fi

if [ -z $dbName ]; then
	echo -n "Database name: "
	read dbName
fi

if [ -z $dbTable ]; then
	echo -n "Database table: "
	read dbTable
fi

if [ $maxRows -eq 0 ]; then
	echo -n "Max rows per file: "
	read maxRows
fi

# set file count
if [ $noSplit -eq 0 ]; then
	count=$(ssh $sshUser@$dbHost 'mysql -u'$dbUser' -p'$dbPass' '$dbName' -e "SELECT CEIL(COUNT(*) / '$maxRows') FROM '$dbTable'" -N')
fi

# create dir based on table name
mkdir $dbTable

# cycle over filecount to generate files
for i in $(seq 1 $count)
do
	offset=$(($maxRows * ($i - 1)))
	#ssh $dbHost 'mysql -u'$dbUser' -p'$dbPass' '$dbName' -e "SELECT * FROM '$dbTable' LIMIT '$offset','$maxRows'" -N' |sed "s/'/\'/;s/\t/\",\"/g;s/^/\"/;s/$/\"/;s/\n//g" > $dbTable/${dbTable}_${i}.csv
	ssh $dbHost 'mysql -u'$dbUser' -p'$dbPass' '$dbName' -e "SELECT * FROM '$dbTable' LIMIT '$offset','$maxRows'" -N' |sed "s/;/\\\;/g" |sed "s/'/\\\'/g" |sed "s/\t/';'/g" |sed "s/^/'/g" |sed "s/$/'/g" > $dbTable/${dbTable}_${i}.csv
done

if [ $compress -eq 1 ]; then
	tar -zcvf $dbTable.tar.gz $dbTable
	rm -rf $dbTable
fi

echo 'Export completed'

exit 0
