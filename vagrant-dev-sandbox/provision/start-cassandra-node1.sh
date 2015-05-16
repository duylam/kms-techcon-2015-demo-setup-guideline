#!/bin/bash

dataHome=$HOME/data/cassandra-node1
binHome=$HOME/apps/cassandra
CASSANDRA_HOME=$dataHome CASSANDRA_CONF=$binHome/conf-node1 $binHome/bin/cassandra -f