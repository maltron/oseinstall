oc project default
oadm registry --replicas=1 --service-account=registry --selector='area=infra' --config=/etc/origin/master/admin.kubeconfig --credentials=/etc/origin/master/openshift-registry.kubeconfig --images='registry.access.redhat.com/openshift3/ose-${component}:${version}'

oadm router default-router --stats-password='maltron' --selector='area=infra' --replicas=1 --service-account=router --config=/etc/origin/master/admin.kubeconfig --credentials=/etc/origin/master/openshift-router.kubeconfig --images='registry.access.redhat.com/openshift3/ose-${component}:${version}'
