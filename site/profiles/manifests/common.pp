# Config common to all machines
class profiles::common {

    include private_init
    include public_init

    # sshd config
    include profiles::ssh::server

    # base firewall config
    include profiles::firewall::setup

    # common packages needed everywhere
    package {[
            'git',
            'screen'
        ]:
        ensure => present,
    }

    # set locale
    class { 'locales':
        default_locale => 'en_US.UTF-8',
        locales        => ['en_US.UTF-8 sv_SE.UTF-8 UTF-8'],
    }
}
