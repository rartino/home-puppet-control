# Home fileserver role
class roles::home_fileserver {

  include profiles::common

  class { '::ntp':
    servers => [ 'pool.ntp.org' ],
  }

  class { 'samba_fileserver':
     use_ldap => false,
  }

  #class { 'minidlna':
  #      dlna_listen_if => fact('networking.primary'),
  #      dlna_media_dirs => [
  #          #"V,/disks/pingu/MEDIA/DVD-MOVIES/",
  #          #"V,/disks/pingu/MEDIA/DVD-SERIES/",
  #          #"V,/disks/pinga/MEDIA/DVD-MOVIES/",
  #          #"V,/disks/pinga/MEDIA/DVD-SERIES/",
  #          "A,/disks/pinga/MEDIA/CD/"],
  #}

  class {
      'plex':
        plex_listen_if => fact('networking.primary'),
        plex_movies_dirs => [
	  "/disks/pingu/MEDIA/DVD-MOVIES/",
          "/disks/pinga/MEDIA/DVD-MOVIES/",  
	],
        plex_video_dirs => [
	  "/disks/pingu/MEDIA/DVD-VIDEO/",
          "/disks/pinga/MEDIA/DVD-VIDEO/",  
	],	
        plex_tv_series_dirs => [
	  "/disks/pingu/MEDIA/DVD-SERIES/",
          "/disks/pinga/MEDIA/DVD-SERIES/",  
	],
	plex_audio_dirs => [
	  "/disks/pingu/MEDIA/CD/",
	  "/disks/pinga/MEDIA/CD/",
	],
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
