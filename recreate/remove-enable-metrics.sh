oc delete all --selector="metrics-infra" --namespace openshift-infra
oc delete sa --selector="metrics-infra" --namespace openshift-infra
oc delete templates --selector="metrics-infra" --namespace openshift-infra
oc delete secrets --selector="metrics-infra" --namespace openshift-infra
oc delete pvc --selector="metrics-infra" --namespace openshift-infra
