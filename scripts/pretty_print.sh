#!/bin/bash -e

print_red(){
  echo -e "\e[31m$1\e[0m"
}
print_green(){
  echo -e "\e[32m$1\e[0m"
}
print_blue(){
  echo -e "\e[34m$1\e[0m"
}
print_yellow(){
  echo -e "\e[33m$1\e[0m"
}
print_white(){
  echo -e "\e[37m$1\e[0m"
}

banner(){
  print_blue "------------------------------------------------"
  print_blue "$1"
  print_blue "------------------------------------------------"
}