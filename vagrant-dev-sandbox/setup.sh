#!/bin/bash

SSH_USER="vagrant"

##########################
# install Java Runtime Environment
##########################
`java -version` || {
  # java is unavailable, install now
  apt-get update
  apt-get install -y default-jre
}


##########################
# add more loopback IPs in order we can launch many Cassandra processes  in single machine
##########################
route add -host 127.0.0.2 dev lo
route add -host 127.0.0.3 dev lo
route add -host 127.0.0.4 dev lo


##########################
# install Cassandra with environment configuration files from provisioning
##########################
[ -f "/home/$SSH_USER/downloads/apache-cassandra-2.1.5-bin.tar.gz" ] || {
  # Cassandra package is unavailable, download from Internet now
  su - $SSH_USER -c 'mkdir ~/downloads'
  
  # hopefully the link is always available 
  su - $SSH_USER -c 'wget -q http://mirrors.maychuviet.vn/apache/cassandra/2.1.5/apache-cassandra-2.1.5-bin.tar.gz -O ~/downloads/apache-cassandra-2.1.5-bin.tar.gz'
}

[ -d "/home/$SSH_USER/apps/apache-cassandra-2.1.5" ] || {
  # extract compressed package and create configuration folder for many Cassandra processes
  su - $SSH_USER -c 'mkdir ~/apps'
  su - $SSH_USER -c 'tar -zxf ~/downloads/apache-cassandra-2.1.5-bin.tar.gz -C ~/apps/'
}

su - $SSH_USER -c 'ln -sf ~/apps/apache-cassandra-2.1.5 ~/apps/cassandra'
# separate configuration folders
su - $SSH_USER -c 'cp -r ~/apps/cassandra/conf ~/apps/cassandra/conf-node1'
su - $SSH_USER -c 'cp -r ~/apps/cassandra/conf ~/apps/cassandra/conf-node2'
su - $SSH_USER -c 'cp -r ~/apps/cassandra/conf ~/apps/cassandra/conf-node3'
su - $SSH_USER -c 'cp -r ~/apps/cassandra/conf ~/apps/cassandra/conf-seed'

# copy provisioned environment-specific files for processes
su - $SSH_USER -c 'cp ~/provision/cassandra-conf/cassandra-node1.yaml ~/apps/cassandra/conf-node1/cassandra.yaml'
su - $SSH_USER -c 'cp ~/provision/cassandra-conf/cassandra-node2.yaml ~/apps/cassandra/conf-node2/cassandra.yaml'
su - $SSH_USER -c 'cp ~/provision/cassandra-conf/cassandra-node3.yaml ~/apps/cassandra/conf-node3/cassandra.yaml'
su - $SSH_USER -c 'cp ~/provision/cassandra-conf/cassandra-seed.yaml ~/apps/cassandra/conf-seed/cassandra.yaml'


##########################
# create data and log folders for Cassandra process (follow pre-defined structure by Cassandra)
##########################
su - $SSH_USER -c 'mkdir ~/data'

su - $SSH_USER -c 'mkdir ~/data/cassandra-node1'
su - $SSH_USER -c 'ln -sf ~/apps/cassandra/lib ~/data/cassandra-node1/' # copy cassandra .jar files
su - $SSH_USER -c 'mkdir ~/data/cassandra-node1/logs'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node1/data'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node1/data/data'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node1/data/commitlog'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node1/data/saved_caches'

su - $SSH_USER -c 'mkdir ~/data/cassandra-node2'
su - $SSH_USER -c 'ln -sf ~/apps/cassandra/lib ~/data/cassandra-node2/' # copy cassandra .jar files
su - $SSH_USER -c 'mkdir ~/data/cassandra-node2/logs'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node2/data'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node2/data/data'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node2/data/commitlog'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node2/data/saved_caches'

su - $SSH_USER -c 'mkdir ~/data/cassandra-node3'
su - $SSH_USER -c 'ln -sf ~/apps/cassandra/lib ~/data/cassandra-node3/' # copy cassandra .jar files
su - $SSH_USER -c 'mkdir ~/data/cassandra-node3/logs'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node3/data'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node3/data/data'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node3/data/commitlog'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node3/data/saved_caches'

su - $SSH_USER -c 'mkdir ~/data/cassandra-seed'
su - $SSH_USER -c 'ln -sf ~/apps/cassandra/lib ~/data/cassandra-seed/' # copy cassandra .jar files
su - $SSH_USER -c 'mkdir ~/data/cassandra-seed/logs'
su - $SSH_USER -c 'mkdir ~/data/cassandra-seed/data'
su - $SSH_USER -c 'mkdir ~/data/cassandra-seed/data/data'
su - $SSH_USER -c 'mkdir ~/data/cassandra-seed/data/commitlog'
su - $SSH_USER -c 'mkdir ~/data/cassandra-seed/data/saved_caches'


##########################
# enable execution permission on provisioned shell files
##########################
su - $SSH_USER -c 'chmod 755 ~/provision/*.sh'
