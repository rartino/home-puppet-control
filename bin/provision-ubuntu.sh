#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: $0 <system_id>"
    exit 1
fi
SYSTEM_ID="$1"

apt-get update -y
apt-get install -y git puppet r10k

rm -f /etc/puppet/hiera.yaml
cd /etc/puppet/code
mkdir -p local-modules
git clone git@github.com:rartino/home-puppet-modules.git local-modules/home

mkdir -p /etc/facter/facts.d/
echo "system_id=$SYSTEM_ID" > /etc/facter/facts.d/system_id.txt

cat > r10k.yaml <<EOF
:sources:
  :base:
    remote: 'https://github.com/rartino/home-puppet-control.git'
    basedir: 'environments'
EOF
export RUBYOPT='-W:no-deprecated'
r10k deploy environment -p -v
# puppet apply /etc/puppet/code/environments/production/manifests/site.pp

#--confdir=/etc/puppet/
