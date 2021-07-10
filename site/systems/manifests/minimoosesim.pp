# Minimoose is our home fileserver
class systems::minimoosesim {

      class { 'hostname':
        hostname => "minimoose",
        domain => "home",
      }

      class { 'roles::home_fileserver':
	main_net_if => "enp0s3",
	bridge_net_if => "enp0s8",
      }

}
