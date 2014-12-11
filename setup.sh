#!/bin/bash

yum -y update

yum -y install unzip oracle-rdbms-server-11gR2-preinstall

echo oracle | passwd --stdin oracle
echo -e 'oracle\tALL=(ALL)\tNOPASSWD: ALL' >/etc/sudoers.d/oracle

cat <<EOF  >>/home/oracle/.bash_profile
export ORACLE_BASE=/u01/app/oracle 
export ORACLE_HOME=\${ORACLE_BASE:?}/product/11.2.0/db_1
export ORACLE_SID=oemrepo
export PATH=\$PATH:\$ORACLE_HOME/bin
EOF

sed -i -e '/requiretty$/s/^/#/' -e'/visiblepw$/s/!//'  /etc/sudoers

mkdir -p /u01/app/oracle
chown -R oracle:oinstall /u01

[ -d /vagrant/database ] || {
unzip -u -d /vagrant /tmp/p10404530_112030_Linux-x86-64_1of7.zip
unzip -u -d /vagrant /tmp/p10404530_112030_Linux-x86-64_2of7.zip
}

su -c "/vagrant/database/runInstaller -silent -showProgress -ignorePrereq -responseFile /vagrant/db.rsp -waitforcompletion" - oracle

su -c 'netca -silent -responseFile $ORACLE_HOME/assistants/netca/netca.rsp' - oracle

su -c 'unzip -u -d ${ORACLE_HOME:?}//assistants/dbca/templates /vagrant/11.2.0.3_Database_Template_for_EM12_1_0_4_Linux_x64.zip' - oracle

su -c 'dbca -silent -createDatabase -responseFile /vagrant/dbca.rsp' - oracle
