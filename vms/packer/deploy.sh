#!/bin/bash -e
#
#
#
export UBUNTU_ISO

UBUNTU_ISO="$(dirname $0)/iso/ubuntu-22.04.1-live-server-amd64.iso"


show_usage() {
  [[ "$1" == "" ]] && echo "Error: $1"
  echo " "
  echo "$(basename $0) -h|--help"
  echo "$(basename $0) <create|delete|list> [vm_name]"
  echo " "
}

store_secret(){
  echo "------------------CONFIG------------------"
  echo "#ToDo: This needs to be stored in 1Password"
  echo "encryption_secret: '$1'"
  echo "------------------------------------------"
}

create_password(){
  echo "password"
}

encrypt_vm(){
    echo "encrypting vm"
    PASSWORD="$(create_password)"
    echo "${PASSWORD}" | prlctl encrypt "${vm_name}"
    store_secret "${PASSWORD}"
}

decrypt_vm(){
  echo "decrypting vm"
  echo "$1" | prlctl decrypt_vm
}
#
#
#
create_vm() {
  vm_name="$1"
  VBoxManage createvm --name "${vm_name}" --ostype="linux" --register
  VBoxManage modifyvm "${vm_name}" --cpus=2 \
                                   --memory=2048 \
                                   --firmware=bios \
                                   --paravirt-provider=default \
                                   --mouse=ps2 \
                                   --keyboard=ps2 \
                                   --audio-driver=none \
                                   --audio-enabled=off \
                                   --
#  VBoxManage set "${vm_name}" --description "Created by $0 on $(date)"
#  VBoxManage set "${vm_name}" --tools-autoupdate on
#  VBoxManage set "${vm_name}" --asset-id "$(uuidgen)"
#  VBoxManage set "${vm_name}" --device-del usb --disable || true
#  VBoxManage set "${vm_name}" --device-del sound0 --disable || true
#  VBoxManage set "${vm_name}" --device-set cdrom0 --enable --image "${UBUNTU_ISO}" --connect
#  VBoxManage set "${vm_name}" --device-set net --net_id net0 --type shared --enable --connect || true
#  VBoxManage set "${vm_name}" --device-del serial0 --disable || true
#  VBoxManage set "${vm_name}" --device-del parallel0 --disable || true
  VBoxManage startvm "${vm_name}"
  # ToDo: send boot command
#  encrypt_vm
}

list_vm() {
  prlctl list --all
}

delete_vm() {
  vm_name="$1"
  prlctl stop "${vm_name}" --kill || true
  prlctl delete "${vm_name}"
}
#
#
#
[[ -z "$1" ]] && show_usage "missing command"
case "$1" in
"-h")
  show_usage
  ;;
"--help")
  show_usage
  ;;
"list")
  list_vm
  ;;
"create")
  [[ -z "$2" ]] && show_usage "missing vm_name"
  create_vm "$2"
  ;;
"delete")
  [[ -z "$2" ]] && show_usage "missing vm_name"
  delete_vm "$2"
  ;;
"*")
  echo "unrecognized command $*"
  ;;
esac
