# Large Messages Shovelling

Shovel large messages in a low-bandwidth network (e.g. 50 MB messages, network 750 kbps).

Original thread: https://groups.google.com/forum/#!topic/rabbitmq-users/rv0vj30dnY8

## Pre-requisites

VirtualBox and Vagrant (2.x+).

## Setup

```
$ git clone git@github.com:rabbitmq/shovel-large-messages.git
$ cd shovel-large-messages
$ vagrant up
$ vagrant ssh node1
node1 $ /vagrant/install.sh
node1 $ /vagrant/declare-shovel.sh
node1 $ exit
$ vagrant ssh node2
node2 $ /vagrant/install.sh
```

Management plugin is available on http://192.168.33.11:15672 and http://192.168.33.12:15672 (user / password id admin / admin).

## Sending messages

The `send-messages.groovy` script can publish large messages periodically. Launch it from `node1` with `groovy /vagrant/send-messages.groovy`.

## Shovelling

The default configured shovel is on `node1` and shovels from `node1#shovel-source` to `node2#shovel-destination`. The `send-messages.groovy` script can be used to send large messages to `node1#shovel-source` to start the shovelling.

## Useful commands

```
# limit output rate to 750Kbits
sudo tc qdisc add dev eth1 root tbf rate 750Kbit burst 32kbit latency 400ms
# list default queuing disciplines
sudo tc qdisc show
# delete limiting disciplines
sudo tc qdisc del dev eth1 root

groovy /vagrant/send-messages.groovy
tail -n 50 -f /var/log/rabbitmq/rabbit@vm-node1.log
tail -n 50 -f /var/log/rabbitmq/rabbit@vm-node2.log
```
