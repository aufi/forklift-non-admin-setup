USERNAME = user1
PASSWORD ?= ${RANDOM}
FORKLIFT_NAMESPACE = openshift-mtv	# hardcoded also in yamls

# NOTE: this Makefile is not fully working

setup: user-create role-create

cleanup: role-delete user-delete

user-create:
	# prepare htpasswd file - DO THIS MANUALLY EDIT OC OAUTH CLUSTER
	echo ${PASSWORD} > .password_plaintext
	htpasswd -cb htpasswd ${USERNAME} ${PASSWORD}
	# store htpasswd to secret and create corresponding identity provider
	oc create secret generic m-htpass-secret --from-file=.htpasswd
	#oc create -f idp_htpasswd.yaml
	echo "Created OpenShift User ${USERNAME} with password ${PASSWORD}"

user-delete:
	oc delete secret m-htpass-secret
	oc delete -f idp_htpasswd.yaml

role-create:
	oc create -f forklift_nonadmin_role.yaml
	oc adm policy add-role-to-user forklift-nonadmin ${USERNAME}  --role-namespace openshift-mtv -n ${FORKLIFT_NAMESPACE}

role-delete:
	oc adm policy remove-role-to-user forklift-nonadmin-role ${USERNAME} -n ${FORKLIFT_NAMESPACE}
	oc delete -f forklift_user_role.yaml

