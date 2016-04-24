echo ">>> Restart atomic-openshift-master"
systemctl restart docker; systemctl restart atomic-openshift-node; systemctl restart atomic-openshift-master
echo ">>> Restart Node1:atomic-openshift-node"
ssh node1.openshift.com "systemctl restart docker; systemctl restart atomic-openshift-node"
