#!/bin/bash
# Update the OS
sudo yum -y -q update
# Add the prereqs
sudo yum -y -q install unzip oracle-rdbms-server-11gR2-preinstall
# Construct the needed oracle environment
sudo su -c 'cat /vagrant/oracle_profile  >>/home/oracle/.bash_profile' - oracle
# Ensure that user oracle can be used by the OEM Manager
sudo sed -i -e '/requiretty$/s/^/#/' -e'/visiblepw$/s/!//'  /etc/sudoers
# Construct the ORACLE_BASE
sudo mkdir -p /u01/app/oracle
sudo chown -R oracle:oinstall /u01

# Unzip the database install files, if not already done
[ -d /vagrant/database ] || {
unzip -u -d /vagrant /vagrant/p10404530_112030_Linux-x86-64_1of7.zip
unzip -u -d /vagrant /vagrant/p10404530_112030_Linux-x86-64_2of7.zip
}

# Install the db
sudo su -c "/vagrant/database/runInstaller -silent -ignorePrereq -responseFile /vagrant/db.rsp -waitforcompletion" - oracle

# Execute the root scripts
sudo /u01/app/oraInventory/orainstRoot.sh
sudo /u01/app/oracle/product/11.2.0/db_1/root.sh

# Configure the listener
sudo su -c 'netca -silent -responseFile $ORACLE_HOME/assistants/netca/netca.rsp' - oracle

# Unzip the templates into the VM
sudo su -c 'unzip -u -d ${ORACLE_HOME:?}/assistants/dbca/templates /vagrant/11.2.0.3_Database_Template_for_EM12_1_0_4_Linux_x64.zip' - oracle

# Clone a DB for OEM from the templates
sudo su -c 'dbca -silent -createDatabase -responseFile /vagrant/dbca.rsp' - oracle

# Create a DB service
sudo cp /vagrant/dbora /etc/init.d
sudo chmod 755 /etc/init.d/dbora
sudo chkconfig --add dbora

sudo sed -i 's/N$/Y/' /etc/oratab
sudo service dbora start

# Patch the db for OEM
sudo su -c 'sqlplus / as sysdba @/vagrant/patch.sql' - oracle
