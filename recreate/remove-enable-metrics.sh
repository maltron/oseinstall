oc delete all,sa,templates,secrets,pvc --selector="metrics-infra" -n openshift-infra
oc delete sa,secret metrics-deployer -n openshift-infra
