# Home fileserver role
class roles::home_fileserver {

  include profiles::common

  class { '::ntp':
    servers => [ 'pool.ntp.org' ],
  }

  class { '::samba::classic':
    domain             => 'DC',
    realm              => 'dc.home',
    smbname            => 'SMB2',
    sambaloglevel      => 1,
    logtosyslog        => true,
    sambaclassloglevel => {
      'smb'     => 2,
      'idmap'   => 2,
      'winbind' => 2,
    },
    globaloptions      => {
      'winbind cache time' => 10,
    },
#    globaloptions       => {},
#    globalabsentoptions => [],
  }

  # recover uid and gid from Domain Controler (unix attributes)
  ::samba::idmap { 'Domain DC':
    domain      => 'DC',
    idrangemin  => 10000,
    idrangemax  => 19999,
    backend     => 'ad',
    schema_mode => 'rfc2307',
  }

  # a default map (*) is needed for idmap to work
  ::samba::idmap { 'Domain *':
    domain     => '*',
    idrangemin => 100000,
    idrangemax => 199999,
    backend    => 'tdb',
  }
  ::samba::share { 'Test Share':
    path    => '/media/',
    mode    => '0750',
    owner   => 'root',
    group   => 'domain users',
    options => {
      'comment'   => 'Media',
      'browsable' => 'Yes',
      'read only' => 'No',
    },
    acl     =>
      [
        'group::rwx',
        'd:group:wtest group:rwx',
        'd:group:rtest group:r-x',
        'mask::rwx' ,
        'other::---',
        'user::rwx',
      ],
  }

  ::samba::share { 'homes':
    path    => '/srv/home/home_%U',
    options => {
      'comment'        => 'Home Folder',
      'browsable'      => 'No',
      'read only'      => 'No',
      'directory mask' => '700',
      'create mask'    => '700',
      'root preexec'   => "smb-create-home.sh -d \
/srv/home/home_%U -u %U -m 700",
    },
  }
}
