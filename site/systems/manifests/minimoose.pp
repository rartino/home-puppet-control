# Minimoose is our home fileserver
class systems::minimoose {

      class { 'hostname':
        hostname => "minimoose",
        domain => "home"
      }

      include roles::home_fileserver
}
