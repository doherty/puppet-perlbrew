# == Class: perlbrew
#
# This class arranges for perlbrew to be installed in /opt/perlbrew.
# This doesn't install any perl binaries yet, it simply makes the
# perlbrew tool available to users on the machine. You could also
# have puppet use perlbrew to install some perl binaries.
#
# === Parameters
#
# None.
#
# === Variables
#
# None.
#
# === Examples
#
#    include perlbrew
#
# === Authors
#
# Mike Doherty <mike@mikedoherty.ca>
#
# === Copyright
#
# Copyright 2013 Mike Doherty, unless otherwise noted.
#

class perlbrew {
    package { 'curl': ensure => installed }
    package { 'bash': ensure => installed }
    exec { 'install perlbrew':
        command     => '/usr/bin/curl -L http://install.perlbrew.pl | /bin/bash',
        require     => [ Package['curl'], Package['bash'] ],
        creates     => '/opt/perlbrew/bin/perlbrew',
        environment => [ 'PERLBREW_ROOT=/opt/perlbrew', ],
        user        => 'root',
    }
    file { '/etc/profile.d/perlbrew.sh':
        ensure  => file,
        content => 'export PATH="$PATH:/opt/perlbrew/bin"',
        owner   => 'root',
        group   => 'root',
        mode    => 0644,
        require => Exec['install perlbrew'],
    }
}
