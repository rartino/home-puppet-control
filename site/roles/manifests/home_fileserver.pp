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
        log_file                => '/var/log/samba/log.%m',
        max_log_size            => '1000',
        syslog                  => '0',
        panic_action            => '/usr/share/samba/panic-action %d',
        server_role             => 'standalone server',
        passdb_backend          => 'tdbsam',
        obey_pam_restrictions   => 'yes',
        unix_password_sync      => 'yes',
        passwd_program          => '/usr/bin/passwd %u',
        passwd_chat             => '*Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .',
        pam_password_change     => 'yes',
        map_to_guest            => 'Never',
        usershare_allow_guests  => 'yes',
        #interfaces             => "eth0 lo",
        bind_interfaces_only    => 'no',
        security                => 'user',
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
#    force_group               => 'group',
#    force_user                => 'user',
#    copy                      => 'some-other-share',
    hosts_allow               => '127.0.0.1, 192.168.1.',
    acl_allow_execute_always  => true,
  }

  firewall { '100 allow samba access':
    dport   => [139, 445],
    proto  => 'tcp',
    action => 'accept',
  }

}
