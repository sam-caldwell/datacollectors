SERVER_ISO:="${HOME}/iso/ubuntu-22.04.1-live-server-amd64.iso"
SERVER_ISO_URL:="https://releases.ubuntu.com/22.04/ubuntu-22.04.1-live-server-amd64.iso"
SERVER_ISO_HASH:="sha256:10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"

# ToDo: register the vagrant box
packer/build/vm:
	@echo "$@ starting..."
	(\
		cd vms/packer; \
		packer build -only=parallels-iso.vm -var-file=os_pkrvars/ubuntu-22.04-x86_64.pkrvars.hcl packer_templates; \
		make vagrant/build/box; \
		echo "$@ completed" \
	)

