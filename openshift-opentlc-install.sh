cat << EOF > /etc/yum.repos.d/open.repo
[rhel-7-server-rpms]
name=Red Hat Enterprise Linux 7 RPMS
baseurl=http://www.opentlc.com/repos/rhel-7-server-rpms
enabled=1
gpgcheck=0

[rhel-7-server-extras-rpms]
name=Red Hat Enterprise Linux 7 Extras RPMS
baseurl=http://www.opentlc.com/repos/rhel-7-server-extras-rpms
enabled=1
gpgcheck=0

[rhel-7-server-ose-3.1-rpms]
name=Red Hat Enterprise Linux 7 Server OpenShift Enterprise 3.1
baseurl=http://www.opentlc.com/repos/rhel-7-server-ose-3.1-rpms
enabled=1
gpgcheck=0

[rhel-ha-for-rhel-7-server-rpms]
name=Red Hat Enterprise Linux 7 High Availbility
baseurl=http://www.opentlc.com/repos/rhel-ha-for-rhel-7-server-rpms
enabled=1
gpgcheck=0

EOF

yum clean all; yum repolist; yum update; yum -y install bind bind-utils bash-completion vim

export GUID=`hostname|cut -f2 -d-|cut -f1 -d.`
export guid=`hostname|cut -f2 -d-|cut -f1 -d.`
HostIP=`host infranode00-$GUID.oslab.opentlc.com  ipa.opentlc.com |grep infranode | awk '{print $4}'`
domain="cloudapps-$GUID.oslab.opentlc.com"

cat << EOF >> /etc/hosts
192.168.0.100 master00-${GUID}.oslab.opentlc.com master00-${GUID}
192.168.0.101 infranode00-${GUID}.oslab.opentlc.com infranode00-${GUID}
192.168.0.200 node00-${GUID}.oslab.opentlc.com node00-${GUID}
192.168.0.201 node01-${GUID}.oslab.opentlc.com node01-${GUID}
EOF

for node in master00-${GUID}.oslab.opentlc.com infranode00-${GUID}.oslab.opentlc.com node00-${GUID}.oslab.opentlc.com node01-${GUID}.oslab.opentlc.com; do ssh ${node} "cat << EOF >> /etc/hosts
192.168.0.100 master00-${GUID}.oslab.opentlc.com master00-${GUID}
192.168.0.101 infranode00-${GUID}.oslab.opentlc.com infranode00-${GUID}
192.168.0.200 node00-${GUID}.oslab.opentlc.com node00-${GUID}
192.168.0.201 node01-${GUID}.oslab.opentlc.com node01-${GUID}
EOF"; done

echo StrictHostKeyChecking no >> /etc/ssh/ssh_config
ssh master00-${GUID} "echo StrictHostKeyChecking no >> /etc/ssh/ssh_config"

for node in master00-${GUID}.oslab.opentlc.com infranode00-${GUID}.oslab.opentlc.com node00-${GUID}.oslab.opentlc.com node01-${GUID}.oslab.opentlc.com; do scp /etc/yum.repos.d/open.repo ${node}:/etc/yum.repos.d/open.repo; ssh ${node} "yum clean all; yum repolist; yum -y update"; ssh ${node} "yum -y remove NetworkManager*; yum -y install docker"; done

for node in master00-${GUID}.oslab.opentlc.com infranode00-${GUID}.oslab.opentlc.com node00-${GUID}.oslab.opentlc.com node01-${GUID}.oslab.opentlc.com; do ssh ${node} "sed -i \"s/OPTIONS.*/OPTIONS='--selinux-enabled --insecure-registry 172.30.0.0\/16'/\" /etc/sysconfig/docker" ; done

for node in master00-${GUID}.oslab.opentlc.com infranode00-${GUID}.oslab.opentlc.com node00-${GUID}.oslab.opentlc.com node01-${GUID}.oslab.opentlc.com; do ssh ${node} "systemctl stop docker; rm -rf /var/lib/docker/*" ; done

for node in master00-${GUID}.oslab.opentlc.com infranode00-${GUID}.oslab.opentlc.com node00-${GUID}.oslab.opentlc.com node01-${GUID}.oslab.opentlc.com; do ssh ${node} "cat <<EOF > /etc/sysconfig/docker-storage-setup
DEVS=/dev/vdb
VG=docker-vg
EOF"; done

for node in master00-${GUID}.oslab.opentlc.com infranode00-${GUID}.oslab.opentlc.com node00-${GUID}.oslab.opentlc.com node01-${GUID}.oslab.opentlc.com; do ssh ${node} "docker-storage-setup; systemctl start docker; systemctl enable docker" ; done


## LAST LINE WORKED
ssh master00-${GUID}.oslab.opentlc.com "mkdir -p ~/.ssh; rm -rf id_rsa; rm -rf id_rsa.pub; rm -rf authorized_keys;"
ssh master00-6463 "mkdir -p ~/.ssh; rm -rf ~/.ssh/id_rsa; rm -rf ~/.ssh/id_rsa.pub; ssh-keygen -q -t rsa -b 1024 -f /root/.ssh/id_rsa -N ''" 


ssh master00-${GUID}.oslab.opentlc.com "yum -y install wget git net-tools bind-utils iptables-services bridge-utils bash-completion httpd-tools atomic-openshift-utils nfs-server rpcbind"


mkdir -p /var/named/zones

echo "\$ORIGIN  .
\$TTL 1  ;  1 seconds (for testing only)
${domain} IN SOA master.${domain}.  root.${domain}.  (
  2011112904  ;  serial
  60  ;  refresh (1 minute)
  15  ;  retry (15 seconds)
  1800  ;  expire (30 minutes)
  10  ; minimum (10 seconds)
)
  NS master.${domain}.
\$ORIGIN ${domain}.
test A ${HostIP}
* A ${HostIP}"  >  /var/named/zones/${domain}.db

echo "// named.conf
options {
  listen-on port 53 { any; };
  directory \"/var/named\";
  dump-file \"/var/named/data/cache_dump.db\";
  statistics-file \"/var/named/data/named_stats.txt\";
  memstatistics-file \"/var/named/data/named_mem_stats.txt\";
  allow-query { any; };
  recursion yes;
  /* Path to ISC DLV key */
  bindkeys-file \"/etc/named.iscdlv.key\";
};
logging {
  channel default_debug {
    file \"data/named.run\";
    severity dynamic;
  };
};
zone \"${domain}\" IN {
  type master;
  file \"zones/${domain}.db\";
  allow-update { key ${domain} ; } ;
};" > /etc/named.conf

chgrp named -R /var/named ; \
 chown named -Rv /var/named/zones ; \
 restorecon -Rv /var/named ; \
 chown -v root:named /etc/named.conf ; \
 restorecon -v /etc/named.conf ;

systemctl enable named && \
 systemctl start named


