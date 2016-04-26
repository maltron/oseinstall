REGISTRY='192.168.56.100:5555'

docker tag b75276b403e3 ${REGISTRY}/openshift3/image-inspector:latest               ;docker push ${REGISTRY}/openshift3/image-inspector:latest
docker tag bcdee35ffa92 ${REGISTRY}/openshift3/node:latest                          ;docker push ${REGISTRY}/openshift3/node:latest
docker tag 7ee9fa6c7597 ${REGISTRY}/openshift3/ose-sti-builder:latest               ;docker push ${REGISTRY}/openshift3/ose-sti-builder:latest
docker tag aefb1274aacc ${REGISTRY}/openshift3/ose-docker-builder:latest            ;docker push ${REGISTRY}/openshift3/ose-docker-builder:latest
docker tag cb7cc942539a ${REGISTRY}/openshift3/ose-deployer:latest                  ;docker push ${REGISTRY}/openshift3/ose-deployer:latest
docker tag d4bcc0e527ff ${REGISTRY}/openshift3/ose-f5-router:latest                 ;docker push ${REGISTRY}/openshift3/ose-f5-router:latest
docker tag 2b96d2bcbc46 ${REGISTRY}/openshift3/ose-pod:latest                       ;docker push ${REGISTRY}/openshift3/ose-pod:latest
docker tag b4802aef71cd ${REGISTRY}/openshift3/ose-haproxy-router:latest            ;docker push ${REGISTRY}/openshift3/ose-haproxy-router:latest
docker tag 12cc7a5cb779 ${REGISTRY}/openshift3/ose-docker-registry:latest           ;docker push ${REGISTRY}/openshift3/ose-docker-registry:latest
docker tag f7dbc988d7ac ${REGISTRY}/openshift3/ose-keepalived-ipfailover:latest     ;docker push ${REGISTRY}/openshift3/ose-keepalived-ipfailover:latest
docker tag 241740ca4f29 ${REGISTRY}/openshift3/openvswitch:latest                   ;docker push ${REGISTRY}/openshift3/openvswitch:latest
docker tag c437613ea3c5 ${REGISTRY}/openshift3/ose-recycler:latest                  ;docker push ${REGISTRY}/openshift3/ose-recycler:latest
docker tag e9c4d9124920 ${REGISTRY}/openshift3/ose:latest                           ;docker push ${REGISTRY}/openshift3/ose:latest
docker tag becf3413dac1 ${REGISTRY}/openshift3/metrics-deployer:latest              ;docker push ${REGISTRY}/openshift3/metrics-deployer:latest
docker tag 35d99e7e8c51 ${REGISTRY}/openshift3/logging-deployment:latest            ;docker push ${REGISTRY}/openshift3/logging-deployment:latest
docker tag 2ff00fc36375 ${REGISTRY}/openshift3/metrics-heapster:latest              ;docker push ${REGISTRY}/openshift3/metrics-heapster:latest
docker tag 3ce38d905617 ${REGISTRY}/openshift3/logging-kibana:latest                ;docker push ${REGISTRY}/openshift3/logging-kibana:latest
docker tag 4570bca558aa ${REGISTRY}/openshift3/logging-fluentd:latest               ;docker push ${REGISTRY}/openshift3/logging-fluentd:latest
docker tag c3a565b4b085 ${REGISTRY}/openshift3/logging-elasticsearch:latest         ;docker push ${REGISTRY}/openshift3/logging-elasticsearch:latest
docker tag 954fb4dca43f ${REGISTRY}/openshift3/logging-auth-proxy:latest            ;docker push ${REGISTRY}/openshift3/logging-auth-proxy:latest
docker tag 5c02894a36cd ${REGISTRY}/openshift3/metrics-hawkular-metrics:latest      ;docker push ${REGISTRY}/openshift3/metrics-hawkular-metrics:latest
docker tag 12d617a9aa1c ${REGISTRY}/openshift3/metrics-cassandra:latest             ;docker push ${REGISTRY}/openshift3/metrics-cassandra:latest

