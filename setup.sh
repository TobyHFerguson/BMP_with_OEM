#!/bin/bash

# yum -y update

# yum -y install unzip oracle-rdbms-server-11gR2-preinstall

# echo oracle | passwd --stdin oracle
# echo -e 'oracle\tALL=(ALL)\tNOPASSWD: ALL' >/etc/sudoers.d/oracle

# cat <<EOF  >>/home/oracle/.bash_profile
# export ORACLE_BASE=/u01/app/oracle 
# export ORACLE_HOME=\${ORACLE_BASE:?}/product/11.2.0/db_1
# export ORACLE_SID=oemrepo
# export PATH=\$PATH:\$ORACLE_HOME/bin
# EOF

# sed -i -e '/requiretty$/s/^/#/' -e'/visiblepw$/s/!//'  /etc/sudoers

# mkdir -p /u01/app/oracle
# chown -R oracle:oinstall /u01

# [ -d /vagrant/database ] || {
# unzip -u -d /vagrant /tmp/p10404530_112030_Linux-x86-64_1of7.zip
# unzip -u -d /vagrant /tmp/p10404530_112030_Linux-x86-64_2of7.zip
# }

# /vagrant/database/runInstaller -silent -ignorePrereq -responseFile /vagrant/db.rsp -waitforcompletion 

#  netca -silent -responseFile $ORACLE_HOME/assistants/netca/netca.rsp

# unzip -u -d ${ORACLE_HOME:?}//assistants/dbca/templates /vagrant/11.2.0.3_Database_Template_for_EM12_1_0_4_Linux_x64.zip

#dbca -silent -createDatabase -responseFile /vagrant/dbca.rsp

# sudo cp /vagrant/dbora /etc/init.d
# sudo chmod 755 /etc/init.d/dbora
# sudo chkconfig --add dbora

#
# if [[ -f /etc/oratab ]]
# then
#     sed -i 's/N$/Y/' /etc/oratab
# else
#     echo "$ORACLE_SID:$ORACLE_HOME:Y" >/tmp/oratab
#     sudo mv /tmp/oratab /etc
# fi    

# service dbora start

sqlplus / as sysdba @/vagrant/patch.sql
