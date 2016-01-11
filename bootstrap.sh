#!/usr/bin/env bash
#This shell script is called during Provisioning when a Vagrant Virtual Machine is started because it is called from the Vagrantfile.

cd /vagrant  #This is the vagrant shared folder where the rails app lives

sudo -u postgres psql -c "ALTER ROLE vagrant CREATEDB;"  #Give 'createdb' permission to the 'vagrant' user so the rails app can build its databases

bundle install
bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:data:load

echo "======================"
echo "The Rails app has been configured."
echo "You'll need to SSH into the VM and"
echo " run 'Rails server' to start the web server."
echo "ssh://vagrant:vagrant@127.0.0.1:2222"
