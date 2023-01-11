#!/bin/bash
#==
#   NOTE      - create_db.sh
#   Author    - Ista
#
#   Created   - 2023.01.11
#   Github    - https://github.com/vine91
#   Contact   - vine9151@gmail.com
#/


SERVER_NAME=
DB_PASSWORD=
DB_NAME=
DB_USER_NAME=
DB_USER_PASSWORD=

function create_database()
{
  docker exec -it $SERVER_NAME bash <<EOF
    mysql -u root -p$DB_PASSWORD <<EOF
    use mysql;
    create database $DB_NAME DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    create user '$DB_USER_NAME'@'%' identified by '$DB_USER_PASSWORD';
    GRANT ALL ON $DB_NAME.* TO '$DB_USER_NAME'@'%';
    select host, user, password from user;
    show variables like 'character_set%';
    FLUSH PRIVILEGES;
    exit;
  EOF
EOF
}

function error_exit()
{
  echo -ne "Error: $1\n"
  exit 1
}


#==
#   Starting codes in blew
#/

echo -ne "\nCreate MariaDB database for remote connection...\n"

read -p "Enter the DBServer name: " SERVER_NAME
read -p "Enter the DBServer root password: " DB_PASSWORD
read -p "Enter the database name what you want to create: " DB_NAME
read -p "Enter the user name what you want to create: " DB_USER_NAME
read -p "Enter the user password what you want to create: " DB_USER_PASSWORD

create_database || error_exit "Creation failed."

echo -ne "MariaDB database creation complete!!\n\n"
