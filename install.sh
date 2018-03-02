#!/bin/bash

set -ex

sudo curl -sSL "https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc" | sudo -E apt-key add -
echo "deb https://packages.erlang-solutions.com/ubuntu trusty contrib" | sudo tee -a /etc/apt/sources.list > /dev/null
sudo -E apt-get -yq update &>> ~/apt-get-update.log
sudo -E apt-get -yq --no-install-suggests --no-install-recommends --force-yes install esl-erlang=1:20.0

sudo apt-get install -y init-system-helpers socat adduser logrotate

wget https://dl.bintray.com/rabbitmq/rabbitmq-server-deb/rabbitmq-server_3.6.15-1_all.deb
sudo dpkg --install rabbitmq-server_3.6.15-1_all.deb
sudo rm rabbitmq-server_3.6.15-1_all.deb

sudo rabbitmq-plugins enable rabbitmq_shovel_management

sudo rabbitmqctl add_user admin admin
sudo rabbitmqctl set_permissions admin ".*" ".*" ".*"
sudo rabbitmqctl set_user_tags admin administrator

echo '[{rabbit, [{vm_memory_high_watermark, 0.7}]}].' | sudo tee --append /etc/rabbitmq/rabbitmq.config
sudo service rabbitmq-server restart

#rm rabbitmqadmin
wget http://localhost:15672/cli/rabbitmqadmin
chmod u+x rabbitmqadmin

./rabbitmqadmin --vhost / declare queue name=shovel-source
./rabbitmqadmin --vhost / declare queue name=shovel-destination 'arguments={"x-message-ttl":10000}'

sudo apt-get install unzip zip
curl -s "https://get.sdkman.io" | bash
source "/home/vagrant/.sdkman/bin/sdkman-init.sh"
sdk install java 8u152-zulu
sdk install groovy 2.4.13
