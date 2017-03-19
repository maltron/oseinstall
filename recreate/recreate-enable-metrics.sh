oc project openshift-infra
oc create -n openshift-infra -f - <<API
apiVersion: v1
kind: ServiceAccount
metadata:
  name: metrics-deployer
secrets:
- name: metrics-deployer
API
oadm policy add-role-to-user view system:serviceaccount:openshift-infra:hawkular -n openshift-infra
oadm policy add-role-to-user edit system:serviceaccount:openshift-infra:metrics-deployer
oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:openshift-infra:heapster
oc secrets new metrics-deployer nothing=/dev/null -n openshift-infra
oc new-app -f /usr/share/ansible/openshift-ansible/roles/openshift_hosted_templates/files/v1.4/enterprise/metrics-deployer.yaml \
   --as=system:serviceaccount:openshift-infra:metrics-deployer \
   -p HAWKULAR_METRICS_HOSTNAME=hawkular-metrics.cloudapps.example.com \
   -p USE_PERSISTENT_STORAGE=false -n openshift-infra
