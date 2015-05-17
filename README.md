The presentation slide can be found at *link here*

# Introduction

This repository contains specification for launching an Ubuntu OS virtual machine having a Cassandra cluster with multple nodes. All installation steps for deploying Cassandra cluster have been automated so you can launch and see it with no effort

Below are instructions for launching the Cassandra cluster

1. Get this repository to your local box
1. Install necessary software
1. Basic commands to play with the Cassandra cluster (in virtual machine)
1. How I setup a Cassandra cluster with multiple nodes in single machine (for reference purpose)

# 1. Get this repository to your local box

This Git repository can be retrieved by using either `git clone` or download as zip file. If you don't know what `git clone` is, please look for **Download ZIP** button

# 2. Install necessary software

Below are required software you need to have

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (select installer for your OS in **VirtualBox platform packages**)
1. Install [vagrant](https://www.vagrantup.com/downloads.html)

# 3. Basic commands to play with the Cassandra cluster (in virtual machine)

Please noted that commands listed below are executed in terminal (Command Prompt in Windows) under folder *vagrant-dev-sandbox*

- `vagrant up --provision`: start virtual machine up. After entering the command, you see a lot of messages in console screen to describe what vagrant is doing. The virtual machine is ready when the cursor appears again. The `--provision` flag is required only for the first time of launching and it can be removed in sequence starting (`vagrant up`)
- `vagrant halt`: shutdown the virtual machine. The virtual machine fully stops when the cursor appears again
- `vagrant ssh`: remote to virtual machine using ssh. You're in the virtual machine when the welcome messsage shows up in console screen. To exit the virtual machine, enter `exit`. Note: you can have many remote sessions to virtual machine, just open new terminal, `cd` to *vagrant-dev-sandbox* and enter `vagrant ssh`

# 4. How I setup a Cassandra cluster with multiple nodes in single machine (for reference purpose)


1. add more ips (remove them `sudo route del -host 127.0.0.2`)
  - `sudo route add -host 127.0.0.2 dev lo`
  - `sudo route add -host 127.0.0.3 dev lo`
  - `sudo route add -host 127.0.0.4 dev lo`
1. `mkdir ~/apps`, `mkdir ~/data`, 
1. `mkdir ~/data/cassandra-node1`
  - `mkdir ~/data/cassandra-node1/data`
  - `mkdir ~/data/cassandra-node1/commitlog`
  - `mkdir ~/data/cassandra-node1/saved_caches`
1. `mkdir ~/data/cassandra-node2`
  - `mkdir ~/data/cassandra-node2/data`
  - `mkdir ~/data/cassandra-node2/commitlog`
  - `mkdir ~/data/cassandra-node2/saved_caches`
1. `mkdir ~/data/cassandra-node3`   
  - `mkdir ~/data/cassandra-node3/data`
  - `mkdir ~/data/cassandra-node3/commitlog`
  - `mkdir ~/data/cassandra-node3/saved_caches`
3. setup java
  1. `sudo apt-get update`
  1. `sudo apt-get install default-jre`

### Setup basic stuffs

1. download cassandra http://www.apache.org/dyn/closer.cgi?path=/cassandra/2.1.5/apache-cassandra-2.1.5-bin.tar.gz in host (use the exact version to avoid any changes)
1. in guest `tar -zxf <file>.tar.gz -C ~/apps`
1. `cd ~/apps/apache-cassandra`
1. `cp -R conf conf-seed`, `cp -R conf conf-node1`, `cp -R conf conf-node2`, `cp -R conf conf-node3`
1. copy cassandra config to correct location
  - `cp /host/cassandra/conf-seed/cassandra.yaml ~/apps/apache-cassandra/conf-seed`
  - `cp /host/cassandra/conf-node1/cassandra.yaml ~/apps/apache-cassandra/conf-node1`
  - same for node2 and node3
1. changes I did
  for each cassandra-env.sh
    conf-node1:
      JMX_PORT= 7181
    conf-node2:
      JMX_PORT= 7182
    conf-node3:
      JMX_PORT= 7183
  for each cassandra.yaml
    conf-seed:
      listen_address: 127.0.0.4 
      seeds: "127.0.0.4" 
      rpc_address: 127.0.0.4 
    conf-node1:
      listen_address: 127.0.0.1 
      rpc_address: 127.0.0.1
      seeds: "127.0.0.4" 
    conf-node2:
      listen_address: 127.0.0.2
      rpc_address: 127.0.0.2
      seeds: "127.0.0.4" 
    conf-node3:
      listen_address: 127.0.0.3
      seeds: "127.0.0.4" 
      rpc_address: 127.0.0.3

1. how to start: start-cassndra
1. howto stop : ctrl+C (http://docs.datastax.com/en/cassandra/2.1/cassandra/reference/referenceStopCprocess_t.html)

nodetool status -h 127.0.0.2 -- system

connect any node: 
  - bin/.sqlsh 127.0.0.1/2/3
  - describe keyspace system;
