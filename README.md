The presentation slide can be found at *link here*

# Introduction

This repository contains specification for launching an Ubuntu OS virtual machine having a Cassandra cluster with multple nodes. All installation steps for deploying Cassandra cluster have been automated so you can launch and see it with no effort

Below are instructions for launching the Cassandra cluster

1. Get this repository to your local box
1. Install necessary software
1. Quick look at vagrant's commands
1. Play with the Cassandra cluster
1. How I setup a Cassandra cluster with multiple nodes in single machine (for reference purpose)

# 1. Get this repository to your local box

This Git repository can be retrieved by using either `git clone` or download as zip file. If you don't know what `git clone` is, please look for **Download ZIP** button

# 2. Install necessary software

Below are required software you need to have

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (select installer for your OS in **VirtualBox platform packages**)
1. Install [vagrant](https://www.vagrantup.com/downloads.html)

# 3. Quick look at vagrant's commands

Please noted that commands listed below are executed in terminal (Command Prompt in Windows) under folder *vagrant-dev-sandbox*

- `vagrant up --provision`: start virtual machine up. After entering the command, you see a lot of messages in console screen to describe what vagrant is doing. The virtual machine is ready when the cursor appears again. The `--provision` flag is required only for the first time of launching and it can be removed in sequence starting (`vagrant up`)
- `vagrant halt`: shutdown the virtual machine. The virtual machine fully stops when the cursor appears again
- `vagrant ssh`: remote to virtual machine using ssh. You're in the virtual machine when the welcome messsage shows up in console screen. To exit the virtual machine, enter `exit`. Note: you can have many remote sessions to virtual machine, just open new terminal, `cd` to *vagrant-dev-sandbox* and enter `vagrant ssh`

# 4. Play with the Cassandra cluster

Now you have everything to launch and play on the Cassandra cluster. Go ahead and start up the machine by executing `vagrant up --provision`. The flag `--provision` triggers script file I wrote to automate everything such as downloading Java Runtime and Cassandra, deploy pre-defined configuration files, etc. Please be patient and wait around 10 min for things deployed.

Once the machine is ready, open 04 terminal windows and remote to the Ubuntu server (`vagrant ssh`). We're going to start "seed" Cassandra node first, and when it is ready, we will start Cassandra node 01 and 02. Since Cassandra nodes are run in foreground mode which blocks you from executing other commands, the last terminal window is where you can explore the Cassandra cluster

In terminal 01, type `~/provision/start-cassandra-seed.sh` and wait until the logging message says it's ready for client connection. After that, in terminal 02 and 03, type `~/provision/start-cassandra-node1.sh` and `~/provision/start-cassandra-node2.sh` on each one, then wait for the same ready message in terminal 01. **Note:** to stop nodes, press `Ctrl + C`

Now the Cassandra cluster is ready. You can connect to Cassandra cluster in terminal 04 and explore anything you like. The script `start-cassandra-seed.sh` launches "seed" node listening on `127.0.0.4`, `start-cassandra-node1.sh` on `127.0.0.1` and `start-cassandra-node2.sh` on `127.0.0.2`. To connect to Cassandra cluster, type `~/apps/cassandra/bin/cqlsh 127.0.0.4` (or any of `127.0.0.1`, `127.0.0.2` is ok)

Happy exploring and thanks for your interesting in Cassandra

# 5. How I setup a Cassandra cluster with multiple nodes in single machine (for reference purpose)

This section shows detail what I have done in the Ubuntu server. All steps are listed below and I presume you have basic Linux knowledge

1. If you want to transfer files from your host OS (e.g. Windows) to Ubuntu, please look for setting `config.vm.synced_folder` in **Vagrantfile** file
1. You can reference deployment steps in bash shell file `setup.sh` under *vagrant-dev-sandbox* folder. It is executed by vagrant (specified in **Vagrantfile**) when the Ubuntu is starting up with `--provision` flag
1. You can notice there are configuration files in *provision/cassandra-conf* folder, I copied them from *cassandra.yaml* and *cassandra-env.sh* (look at */home/vagrant/apps/cassandra/conf* folder in Ubuntu server) and made following changes
  - For *cassandra-env-node1.sh* and *cassandra-env-node2.sh*, the port in variable `JMX_PORT` has been changed so that Cassandra nodes don't conflict on JMX port
  - For *cassandra-seed.yaml*, *cassandra-node1.yaml* and *cassandra-node2.yaml*, setting items `listen_address`, `seeds` and `rpc_address` have been changed to appropriate value for each node

### The end
