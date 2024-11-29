#!/bin/bash
#==
#   NOTE      - backup-db.sh
#   Author    - Aru
#
#   Created   - 2024.11.27
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
  echo -ne "${T_CO_BLUE}[SCRIPT]${T_CO_NC}$1"
}

function script_notify_print()
{
  echo -ne "${T_CO_BLUE}[SCRIPT]${T_CO_NC}${T_CO_GREEN}-Notify- $1${T_CO_NC}"
}

function script_error_print()
{
  echo -ne "${T_CO_BLUE}[SCRIPT]${T_CO_NC}${T_CO_RED}-Error- $1${T_CO_NC}"
}

function script_println()
{
  echo -ne "${T_CO_BLUE}[SCRIPT]${T_CO_NC}$1\n"
}

function script_notify_println()
{
  echo -ne "${T_CO_BLUE}[SCRIPT]${T_CO_NC}${T_CO_GREEN}-Notify- $1${T_CO_NC}\n"
}

function script_error_println()
{
  echo -ne "${T_CO_BLUE}[SCRIPT]${T_CO_NC}${T_CO_RED}-Error- $1${T_CO_NC}\n"
}

function error_exit()
{
  script_error_println "$1\n"
  exit 1
}

function print_usage()
{
  echo "usage: backup-db.sh [-h] <container> <src> <des>"
  echo
  echo "Backup gitlab docker volume data as '*.tar'.."
  echo "MIT License <https://github.com/aruyu/sshtar/blob/master/LICENSE/>"
  echo "Report or pull request any time. <https://github.com/aruyu/sshtar/>"
  echo
  echo "options:"
  echo "  -h               This message"
}

function change_own_mod()
{
  chown root:root $1/*
  chmod 600 $1/*
}

function backup_database()
{
  docker exec -it $1 gitlab-rake gitlab:backup:create
  change_own_mod $2
  mv $2/* $3/
}




#==
#   Starting codes in blew
#/

if [[ $EUID -ne 0 ]]; then
  error_exit "This script must be run as ROOT!"
fi




while getopts 'h' flag; do
  case "${flag}" in
    h) h_flag='true';;
    *) script_error_println "Option error.\n";
       print_usage;
       exit 1;;
  esac
done

if [[ ${h_flag} == 'true' ]]; then
  print_usage
  exit
fi

if [[ -z ${*: -3:1} ]]; then
  print_usage
  exit
elif [[ -z ${*: -2:1} ]]; then
  print_usage
  exit
elif [[ -z ${*: -1:1} ]]; then
  print_usage
  exit
fi


container=${*: -3:1}
src=${*: -2:1}
des=${*: -1:1}



script_notify_println "Backup GitlabDB to ${des}/*gitlab_backup.tar"
backup_database ${container} ${src} ${des} || error_exit "GitlabDB Backup Failed!! Gitlab create backup failed."
script_notify_println "GitlabDB Backup Successfully Done."
