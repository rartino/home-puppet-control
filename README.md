# Home puppet control repository

Provision a new system with:
```
wget https://raw.githubusercontent.com/rartino/home-puppet-control/production/bin/provision-ubuntu.sh <computer name>
chmod +x provision-ubuntu.sh
sudo SSH_AUTH_SOCK="$SSH_AUTH_SOCK" ./provision-ubuntu.sh "$2" secrets
```
Available computer names:
- `minimoose`: our central media server

## In the repo

Puppetfile: indicates which external puppet modules to use.

## When installed

/root/control/puppet-update: updates and applies the puppet config
/root/puppet/home-puppet-control: location of the git checkout of the control repository
/root/puppet/private-puppet-modules: symlink to the checked out git repo for private modules
/root/puppet/public-puppet-modules: symlink to the checked out git repo for public modules
