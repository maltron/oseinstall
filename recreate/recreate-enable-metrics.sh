oc project openshift-infra
oadm policy add-role-to-user edit system:serviceaccount:openshift-infra:metrics-deployer
oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:openshift-infra:heapster
oc secrets new metrics-deployer nothing=/dev/null -n openshift-infra
oc new-app -f /usr/share/openshift/examples/infrastructure-templates/enterprise/metrics-deployer.yaml \
   -p HAWKULAR_METRICS_HOSTNAME=hawkular-metrics.cloudapps.example.com \
   -p USE_PERSISTENT_STORAGE=false -n openshift-infra
