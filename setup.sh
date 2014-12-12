#!/bin/bash

sudo yum -y -q update

sudo yum -y -q install unzip oracle-rdbms-server-11gR2-preinstall

sudo su -c 'cat /vagrant/oracle_profile  >>/home/oracle/.bash_profile' - oracle

sudo sed -i -e '/requiretty$/s/^/#/' -e'/visiblepw$/s/!//'  /etc/sudoers

sudo mkdir -p /u01/app/oracle
sudo chown -R oracle:oinstall /u01

[ -d /vagrant/database ] || {
unzip -u -d /vagrant p10404530_112030_Linux-x86-64_1of7.zip
unzip -u -d /vagrant p10404530_112030_Linux-x86-64_2of7.zip
}


sudo su -c "/vagrant/database/runInstaller -silent -ignorePrereq -responseFile /vagrant/db.rsp -waitforcompletion" - oracle

sudo /u01/app/oraInventory/orainstRoot.sh
sudo /u01/app/oracle/product/11.2.0/db_1/root.sh

sudo su -c 'netca -silent -responseFile $ORACLE_HOME/assistants/netca/netca.rsp' - oracle

sudo su -c 'unzip -u -d ${ORACLE_HOME:?}/assistants/dbca/templates /vagrant/11.2.0.3_Database_Template_for_EM12_1_0_4_Linux_x64.zip' - oracle

sudo su -c 'dbca -silent -createDatabase -responseFile /vagrant/dbca.rsp' - oracle

sudo cp /vagrant/dbora /etc/init.d
sudo chmod 755 /etc/init.d/dbora
sudo chkconfig --add dbora

sudo sed -i 's/N$/Y/' /etc/oratab
sudo service dbora start

sudo su -c 'sqlplus / as sysdba @/vagrant/patch.sql' - oracle
