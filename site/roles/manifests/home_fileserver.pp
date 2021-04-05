# Home fileserver role
class roles::home_fileserver {

  include profiles::common

  class { '::ntp':
    servers => [ 'pool.ntp.org' ],
  }

  class { 'samba_fileserver':
     use_ldap => true,
  }

  class { 'minidlna':
        dlna_listen_if => fact('networking.primary'),
        dlna_media_dirs => [
            #"V,/disks/pingu/MEDIA/DVD-MOVIES/",
            #"V,/disks/pingu/MEDIA/DVD-SERIES/",
            #"V,/disks/pinga/MEDIA/DVD-MOVIES/",
            #"V,/disks/pinga/MEDIA/DVD-SERIES/",
            "A,/disks/pinga/MEDIA/CD/"],
  }

  class { 'ripd':
        ripdev => "dvd",
	dvddir => "/disks/minimoose/MEDIA/DVDRIPS",
	cddir => "/disks/minimoose/MEDIA/CDRIPS",
  }

  class { 'ldap::server':
  }

  class { 'ldap::client':
  }

}
