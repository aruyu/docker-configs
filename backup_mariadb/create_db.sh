#!/bin/bash
#==
#   NOTE      - create_db.sh
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

function create_database()
{
  docker exec -it $SERVER_NAME bash <<-REALEND
	mysql -u root -p$DB_PASSWORD <<-EOF
	use mysql;
	create database $DB_NAME DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
	create user '$DB_USER_NAME'@'%' identified by '$DB_USER_PASSWORD';
	GRANT ALL ON $DB_NAME.* TO '$DB_USER_NAME'@'%';
	select host, user, password from user;
	show variables like 'character_set%';
	FLUSH PRIVILEGES;
	exit;
EOF
REALEND
}




#==
#   Starting codes in blew
#/

if [[ $EUID -eq 0 ]]; then
  error_exit "This script must be run as USER!"
fi


script_print "\nCreate MariaDB database for remote connection...\n"

read -p "Enter the DBServer name: " SERVER_NAME
read -p "Enter the DBServer root password: " DB_PASSWORD
read -p "Enter the database name what you want to create: " DB_NAME
read -p "Enter the user name what you want to create: " DB_USER_NAME
read -p "Enter the user password what you want to create: " DB_USER_PASSWORD

create_database || error_exit "Creation failed."

script_print_notify "MariaDB database creation complete!!\n\n"
