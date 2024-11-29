#!/bin/bash
#==
#   NOTE      - backup_db.sh
#   Author    - Aru
#
#   Created   - 2023.01.11
#   Github    - https://github.com/aruyu
#   Contact   - vine9151@gmail.com
#/



T_CO_RED='\e[1;31m'
T_CO_YELLOW='\e[1;33m'
T_CO_GREEN='\e[1;32m'
T_CO_BLUE='\e[1;34m'
T_CO_GRAY='\e[1;30m'
T_CO_NC='\e[0m'

CURRENT_PROGRESS=0

function script_print()
{
  echo -ne "$T_CO_BLUE[SCRIPT]$T_CO_NC$1"
}

function script_print_notify()
{
  echo -ne "$T_CO_BLUE[SCRIPT]$T_CO_NC$T_CO_GREEN-Notify- $1$T_CO_NC"
}

function script_print_error()
{
  echo -ne "$T_CO_BLUE[SCRIPT]$T_CO_NC$T_CO_RED-Error- $1$T_CO_NC"
}

function error_exit()
{
  script_print_error "$1\n\n"
  exit 1
}

IP=192.168.0.249
PORT=3306
BACKUP_DATE=`date +%y%m%d_%H_%M`

function backup_database()
{
  mysqldump -h $IP -P $PORT -u $DB_USER_NAME -p$DB_USER_PASSWORD $DB_NAME > $BACKUP_DATE.sql
}




#==
#   Starting codes in blew
#/

if [[ $EUID -eq 0 ]]; then
  error_exit "This script must be run as USER!"
fi


script_print "\nBackup MariaDB database...\n"

read -p "Enter the database name what you want to backup: " DB_NAME
read -p "Enter the user name what you want to backup: " DB_USER_NAME
read -p "Enter the user password what you want to backup: " DB_USER_PASSWORD
echo

read -p "Enter the PATH which you want to create backup: " -i "$HOME/" -e BACKUP_PATH

cd $BACKUP_PATH

script_print_notify "Backup database to $PWD/$BACKUP_DATE.sql\n\n"
backup_database || error_exit "Backup failed."

script_print_notify "MariaDB database backup complete!!\n\n"
