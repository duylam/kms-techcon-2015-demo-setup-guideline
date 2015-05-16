#!/bin/bash

SSH_USER="vagrant"

##########################
# install Java
##########################
`java -version` || {
  apt-get update
  apt-get install default-jre
}


##########################
# add more IPs
##########################
route add -host 127.0.0.2 dev lo
route add -host 127.0.0.3 dev lo
route add -host 127.0.0.4 dev lo

##########################
# create folders
##########################
su - $SSH_USER -c 'mkdir ~/apps'
su - $SSH_USER -c 'mkdir ~/data'

su - $SSH_USER -c 'mkdir ~/data/cassandra-node1'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node1/data'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node1/commitlog'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node1/saved_caches'

su - $SSH_USER -c 'mkdir ~/data/cassandra-node2'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node2/data'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node2/commitlog'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node2/saved_caches'

su - $SSH_USER -c 'mkdir ~/data/cassandra-node3'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node3/data'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node3/commitlog'
su - $SSH_USER -c 'mkdir ~/data/cassandra-node3/saved_caches'

su - $SSH_USER -c 'mkdir ~/data/cassandra-seed'
su - $SSH_USER -c 'mkdir ~/data/cassandra-seed/data'
su - $SSH_USER -c 'mkdir ~/data/cassandra-seed/commitlog'
su - $SSH_USER -c 'mkdir ~/data/cassandra-seed/saved_caches'

