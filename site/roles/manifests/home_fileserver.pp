# Home fileserver role
class roles::home_fileserver {

  include profiles::common

  class { '::ntp':
    servers => [ 'pool.ntp.org' ],
  }

  class {'samba::server':
        workgroup               => 'WORKGROUP',
        server_string           => "${::hostname}",
        dns_proxy               => 'no',
        usershare_allow_guests  => 'yes',
        bind_interfaces_only    => 'no',
        security                => 'share',
  }

  samba::server::share {'disks':
    comment                   => 'Disks',
    path                      => '/disks',
    guest_only                => true,
    guest_ok                  => true,
    guest_account             => "guest",
    browsable                 => true,
    create_mask               => 0777,
    force_create_mask         => 0777,
    directory_mask            => 0777,
    force_directory_mode      => 0777,
    hosts_allow               => '127.0.0.1, 192.168.1.'
  }

  firewall { '100 allow samba access':
    dport   => [139, 445],
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '101 allow samba udp access':
    dport   => [137, 138],
    proto  => 'udp',
    action => 'accept',
  }

}
