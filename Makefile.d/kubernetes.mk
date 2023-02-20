#
#
#
kube/deploy: kube/deploy/local kube/deploy/staging kube/deploy/prod
	@echo "$@ completed"


kube/deploy/dev:
	KUBE_ENV=dev make kube/deploy/env
	@echo "$@ completed"


kube/deploy/staging:
	KUBE_ENV=staging make kube/deploy/env
	@echo "$@ completed"


kube/deploy/prod:
	KUBE_ENV=production make kube/deploy/env
	@echo "$@ completed"

kube/deploy/env:
	@echo "$@ running for ${KUBE_ENV}"
	@(\
		cd ansible || exit 1; \
		ansible-playbook -i ./${KUBE_ENV} ./main.yml; \
	)
