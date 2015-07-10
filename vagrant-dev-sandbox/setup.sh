#!/bin/bash

SSH_USER="vagrant"

function createDir {
  local cmd="[ -d $1 ] || mkdir $1"
  su - $SSH_USER -c "$cmd"
}

##########################
# install Java Runtime Environment
##########################
echo "Detecting Java runtime"
`java -version` || {
  # java is unavailable, install now
  echo "Updating apt-get"
  apt-get update
  
  echo "Installing Java runtime"
  apt-get install -y default-jre
}


##########################
# add more loopback IPs in order we can launch many Cassandra processes in single machine
# new IP can be removed by `$ sudo route del -host 127.0.0.2`
##########################
route add -host 127.0.0.2 dev lo
route add -host 127.0.0.4 dev lo


##########################
# install Cassandra and prepare configuration files for multi nodes from provisioning location
##########################
[ -d "/home/$SSH_USER/apps/apache-cassandra-2.1.5" ] || {
  # Cassandra package is unavailable, download from Internet now
  createDir '~/downloads'
  
  # hopefully the link is always available 
  echo "Downloading Cassandra"
  su - $SSH_USER -c 'wget -q https://archive.apache.org/dist/cassandra/2.1.5/apache-cassandra-2.1.5-bin.tar.gz -O ~/downloads/apache-cassandra-2.1.5-bin.tar.gz'
  createDir '~/apps'
  su - $SSH_USER -c 'tar -zxf ~/downloads/apache-cassandra-2.1.5-bin.tar.gz -C ~/apps/'
}

su - $SSH_USER -c 'ln -sf ~/apps/apache-cassandra-2.1.5 ~/apps/cassandra' # reduce the path length

# separate configuration folders for nodes
su - $SSH_USER -c 'cp -r ~/apps/cassandra/conf ~/apps/cassandra/conf-node1'
su - $SSH_USER -c 'cp -r ~/apps/cassandra/conf ~/apps/cassandra/conf-node2'
su - $SSH_USER -c 'cp -r ~/apps/cassandra/conf ~/apps/cassandra/conf-seed'

# copy provisioned environment-specific files for nodes
su - $SSH_USER -c 'cp ~/provision/cassandra-conf/cassandra-node1.yaml ~/apps/cassandra/conf-node1/cassandra.yaml'
su - $SSH_USER -c 'cp ~/provision/cassandra-conf/cassandra-env-node1.sh ~/apps/cassandra/conf-node1/cassandra-env.sh'
su - $SSH_USER -c 'cp ~/provision/cassandra-conf/cassandra-node2.yaml ~/apps/cassandra/conf-node2/cassandra.yaml'
su - $SSH_USER -c 'cp ~/provision/cassandra-conf/cassandra-env-node2.sh ~/apps/cassandra/conf-node2/cassandra-env.sh'
su - $SSH_USER -c 'cp ~/provision/cassandra-conf/cassandra-seed.yaml ~/apps/cassandra/conf-seed/cassandra.yaml'


##########################
# create data and log folders following pre-defined structure by Cassandra
##########################

createDir '~/data'

createDir '~/data/cassandra-node1'
createDir '~/data/cassandra-node1/logs'
createDir '~/data/cassandra-node1/data'
createDir '~/data/cassandra-node1/data/data'
createDir '~/data/cassandra-node1/data/commitlog'
createDir '~/data/cassandra-node1/data/saved_caches'

createDir '~/data/cassandra-node2'
createDir '~/data/cassandra-node2/logs'
createDir '~/data/cassandra-node2/data'
createDir '~/data/cassandra-node2/data/data'
createDir '~/data/cassandra-node2/data/commitlog'
createDir '~/data/cassandra-node2/data/saved_caches'

createDir '~/data/cassandra-seed'
createDir '~/data/cassandra-seed/logs'
createDir '~/data/cassandra-seed/data'
createDir '~/data/cassandra-seed/data/data'
createDir '~/data/cassandra-seed/data/commitlog'
createDir '~/data/cassandra-seed/data/saved_caches'

su - $SSH_USER -c 'ln -sf ~/apps/cassandra/lib ~/data/cassandra-node1/' # copy cassandra .jar files
su - $SSH_USER -c 'ln -sf ~/apps/cassandra/lib ~/data/cassandra-node2/' # copy cassandra .jar files
su - $SSH_USER -c 'ln -sf ~/apps/cassandra/lib ~/data/cassandra-seed/' # copy cassandra .jar files

##########################
# enable execution permission for launching scripts
##########################
su - $SSH_USER -c 'chmod 755 ~/provision/*.sh'
