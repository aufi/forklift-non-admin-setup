# A non-admin Forklift user setup

WIP

Sample scripts to setup non-admin OpenShift user to be able use Konveyor's Forklift VM migration tool.

## Steps

First, setup OAuth htpasswd Identity provider in the OpenShift cluster. Start creating htaccess file with user&password:

```
htpasswd -cb htpasswd ${USERNAME} ${PASSWORD}
```

Then go to OpenShift web console: administration-cluster-configuration and add htpasswd provider with pasted file content (or do it in cli: create secret with htaccess file content and oc edit oauth cluster adding the authProvider).


Next, create forklift-nonadmin role (yaml specified in an attached file)

```
oc create -f forklift_nonadmin_role.yaml
```

And assign the forklift-nonadmin role to the user

```
oc adm policy add-role-to-user forklift-nonadmin ${USERNAME} --role-namespace openshift-mtv -n ${FORKLIFT_NAMESPACE}
```

Then test the user login in CLI and get e.g. plans in mtv namespace to verify the user/role works well and check Forklift UI.

## Links

- https://docs.openshift.com/container-platform/4.9/post_installation_configuration/preparing-for-users.html
- https://suraj.pro/post/user-on-os4/
- https://docs.openshift.com/container-platform/4.9/authentication/using-rbac.html

- https://github.com/konveyor/forklift-operator#readme
