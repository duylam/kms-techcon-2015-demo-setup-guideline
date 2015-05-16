#!/bin/bash

dataHome=$HOME/data/cassandra-node2
binHome=$HOME/apps/cassandra
CASSANDRA_HOME=$dataHome CASSANDRA_CONF=$binHome/conf-node2 $binHome/bin/cassandra -f