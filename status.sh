echo ">>> STATUS: Nodes"
oc get nodes
echo ">>> STATUS: Router and Registry"
oc get pods -n default
echo ">>> STATUS: Metrics"
oc get pods -n openshift-infra
