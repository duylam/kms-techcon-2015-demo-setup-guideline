#!/bin/bash

dataHome=$HOME/data/cassandra-node3
binHome=$HOME/apps/cassandra
CASSANDRA_HOME=$dataHome CASSANDRA_CONF=$binHome/conf-node3 $binHome/bin/cassandra -f