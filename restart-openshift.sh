echo ">>> Restart atomic-openshift-node"
ssh node.openshift.com "systemctl restart atomic-openshift-node"
echo ">>> Restart atomic-openshift-master"
systemctl restart atomic-openshift-master
