#!/bin/bash

dataHome=$HOME/data/cassandra-seed
binHome=$HOME/apps/cassandra
CASSANDRA_HOME=$dataHome CASSANDRA_CONF=$binHome/conf-seed $binHome/bin/cassandra -f