# Minimoose is our home fileserver
class systems::minimoose {

      class { 'hostname':
        hostname => "minimoose",
        domain => "home",
      }

      class { 'home_fileserver':
	main_net_if => "eno1",
	bridge_net_if => "enp1s0",
      }

}
