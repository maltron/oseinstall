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

echo StrictHostKeyChecking no >> /etc/ssh/ssh_config
ssh master00-${GUID} "echo StrictHostKeyChecking no >> /etc/ssh/ssh_config"

for node in master00-${GUID}.oslab.opentlc.com infranode00-${GUID}.oslab.opentlc.com node00-${GUID}.oslab.opentlc.com node01-${GUID}.oslab.opentlc.com; do scp /etc/yum.repos.d/open.repo ${node}:/etc/yum.repos.d/open.repo; ssh ${node} "yum clean all; yum repolist; yum -y update"; ssh ${node} "yum -y remove NetworkManager*; yum -y install docker"; done

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


