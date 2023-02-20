vagrant/build/box:
	( \
		cd vms/packer; \
		vagrant box add --name "asymmetric-effort/ubuntu-22.04" images/ubuntu-22.04-x86_64.parallels.box; \
		echo "$@ completed" \
	)