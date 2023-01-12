#!/bin/bash
#==
#   NOTE      - backup_db.sh
#   Author    - Asta
#
#   Created   - 2023.01.11
#   Github    - https://github.com/astaos
#   Contact   - vine9151@gmail.com
#/


IP=192.168.0.249
PORT=3306
DB_NAME=
DB_USER_NAME=
DB_USER_PASSWORD=
BACKUP_PATH=
BACKUP_DATE=`date +%y%m%d_%H_%M`

function backup_database()
{
  mysqldump -h $IP -P $PORT -u $DB_USER_NAME -p$DB_USER_PASSWORD $DB_NAME > $BACKUP_DATE.sql
}

function error_exit()
{
  echo -ne "Error: $1\n\n"
  exit 1
}


#==
#   Starting codes in blew
#/

echo -ne "\nBackup MariaDB database...\n"

read -p "Enter the database name what you want to backup: " DB_NAME
read -p "Enter the user name what you want to backup: " DB_USER_NAME
read -p "Enter the user password what you want to backup: " DB_USER_PASSWORD
echo

read -p "Enter the PATH which you want to create backup: " -i "$HOME/" -e BACKUP_PATH

cd $BACKUP_PATH

echo -ne "Backup database to $PWD/$BACKUP_DATE.sql\n\n"
backup_database || error_exit "Backup failed."

echo -ne "MariaDB database backup complete!!\n\n"
