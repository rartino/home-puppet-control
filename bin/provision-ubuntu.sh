#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

if [ -z "$1" -o -z "$2" ]; then
    echo "Usage: $0 <system_id> <secrets_path>"
    exit 1
fi
SYSTEM_ID="$1"
SECRETS_PATH="$2"

cp -rp "$SECRETS_PATH" /root/secrets

apt-get update -y
apt-get install -y git puppet r10k

rm -f /etc/puppet/hiera.yaml
cd /etc/puppet/code
mkdir -p local-modules
git clone git@github.com:rartino/private-puppet-modules.git local-modules/private
git clone https://github.com/rartino/puppet-modules.git local-modules/public

mkdir -p /etc/facter/facts.d/
echo "system_id=$SYSTEM_ID" > /etc/facter/facts.d/system_id.txt

cat > r10k.yaml <<EOF
:sources:
  :base:
    remote: 'https://github.com/rartino/home-puppet-control.git'
    basedir: 'environments'
EOF
export RUBYOPT='-W:no-deprecated'

mkdir -p /root/control
cat > /root/control/puppet-update <<EOF
r10k deploy environment -p -v
puppet apply /etc/puppet/code/environments/production/manifests/site.pp
EOF
chmod +x /root/control/puppet-update
