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
        security                => 'user',
  }

  samba::server::share {'disks':
    comment                   => 'Disks',
    path                      => '/disks',
    guest_only                => false,
    guest_ok                  => true,
    guest_account             => "guest",
    browsable                 => true,
    create_mask               => 0777,
    force_create_mask         => 0777,
    directory_mask            => 0777,
    force_directory_mode      => 0777,
    hosts_allow               => '127.0.0.1, 192.168.1.',
    writable                  => false,
    read_list                 => "@users"
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

  class { 'minidlna':
        dlna_listen_if => fact('networking.primary'),
        dlna_media_dirs => [
            "V,/disks/pingu/MEDIA/DVD-MOVIES/",
            "V,/disks/pingu/MEDIA/DVD-SERIES/",
            "V,/disks/pinga/MEDIA/DVD-MOVIES/",
            "V,/disks/pinga/MEDIA/DVD-SERIES/",
            "A,/disks/pinga/MEDIA/CD/"],
  }

}
