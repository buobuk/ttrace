#!/usr/bin/env bash
# AutoBestTrace
# @version 0.1.0

## color
RED='\033[0;31m'
BLUE='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

## echo text
Echo_Red(){
    echo -e "${RED}$1${NC}"
}
Echo_Blue(){
    echo -e "${BLUE}$1${NC}"
}
Echo_Green(){
    echo -e "${GREEN}$1${NC}"
}
Echo_Yellow(){
    echo -e "${YELLOW}$1${NC}"
}

keys_order=(0 1 2 3 4 5 6 7 8 9)

declare -A ip_address=(
  ['0']="219.141.136.12"
  ['1']="202.106.50.1"
  ['2']="221.179.155.161"
  ['3']="202.96.209.133"
  ['4']="210.22.97.1"
  ['5']="211.136.112.200"
  ['6']="58.60.188.222"
  ['7']="210.21.196.6"
  ['8']="120.196.165.24"
  ['9']="202.112.14.151"
)

declare -A ip_address_cn=(
  ['0']="北京电信"
  ['1']="北京联通"
  ['2']="北京移动"
  ['3']="上海电信"
  ['4']="上海联通"
  ['5']="上海移动"
  ['6']="广州电信"
  ['7']="广州联通"
  ['8']="广州移动"
  ['9']="成都教育网"
)

init() {
  clear
  # get arch
  get_arch=$(arch)
  repo=https://raw.githubusercontent.com/buobuk/ttrace/main/
  if [[ $get_arch =~ "x86_64" ]];then
      package=${repo}besttrace
  elif [[ $get_arch =~ "aarch64" ]];then
      package=${repo}besttracearm
  else
      Echo_Red "未知平台, 中止运行!"
      exit 1
  fi

  # install wget
  if [ ! -e '/usr/bin/wget' ]; then
    Echo_Yellow "Installing wget ..."
    apt update && apt -y install wget > /dev/null 2>&1
  fi

  # install besttrace
  if [ ! -f besttrace ]; then
    Echo_Yellow "Installing Besttrace ..."
    wget --no-check-certificate -O besttrace $package
    chmod +x besttrace
  fi
  clear
}

next() {
  length=80
  spaces=$(seq -s '-' $length | sed 's/[0-9]//g')
  echo -e "$spaces"
}

get_address_value() {
  local index=$1
  echo ${ip_address_cn[$index]}
}

about() {
    echo ""
    echo " ====================================================================== "
    echo " \                            AutoBestTrace                           / "
    echo " ====================================================================== "
    echo ""
}

main() {
  init
  about

  for key in "${keys_order[@]}"; do
    next
    Echo_Blue "$(get_address_value $key)"
    ./besttrace -g cn -q 1 ${ip_address["$key"]}
  done

  rm -f ttrace.sh
  rm -f besttrace
}

main
