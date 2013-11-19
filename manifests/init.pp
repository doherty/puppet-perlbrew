# == Class: perlbrew
#
# This class arranges for perlbrew to be installed in /opt/perlbrew.
# This doesn't install any perl binaries yet, it simply makes the
# perlbrew tool available to users on the machine. You could also
# have puppet use perlbrew to install some perl binaries.
#
# === Parameters
#
# [*perlbrew_root*]
#   Specifies the $PERLBREW_ROOT to install Perlbrew to. Set to /opt/perlbrew by default.
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

class perlbrew($perlbrew_root = "/opt/perlbrew") {
    package { 'curl': ensure => installed }
    package { 'bash': ensure => installed }
    exec { 'install perlbrew':
        command     => '/usr/bin/curl -L http://install.perlbrew.pl | /bin/bash',
        require     => [ Package['curl'], Package['bash'] ],
        creates     => "${perlbrew_root}/bin/perlbrew",
        environment => [ "PERLBREW_ROOT=${perlbrew_root}", ],
        user        => 'root',
    }
    file { '/etc/profile.d/perlbrew.sh':
        ensure  => file,
        content => "export PATH=\"\$PATH:${perlbrew_root}/bin\"",
        owner   => 'root',
        group   => 'root',
        mode    => 0644,
        require => Exec['install perlbrew'],
    }
}
