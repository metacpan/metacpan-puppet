# Class: timezone
#
# This module manages the timezone on a machine
# Tested with Puppet 2.7 (should work with >=2.6)
#
# Parameters:
#
# region   => 'Europe'
# locality => 'London'
# hwutc    => 'true' (optional, false if your hw clock is in local time)
#
# For timezone name use region Etc, eg region => 'Etc', locality => 'GMT'
#

class timezone (
  $region = 'Etc',
  $locality = 'UTC',
  $hwutc = true){

  file { '/etc/localtime':
    # We copy the timezone file into /etc to cater for
    # situations when /usr is not available
    source  => "file:///usr/share/zoneinfo/${region}/${locality}",
    links   => follow,
    replace => true,
    mode    => '0644',
  }

  # Debian and Enterprise Linux have differing ways of recording
  # clock settings
  case $::osfamily {
    'Debian': {
        package { 'tzdata':
            ensure => present,
            before => File['/etc/localtime'],
        }
        file { '/etc/timezone':
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('timezone/debian.erb'),
        }
    }
    'RedHat': {
        package { 'tzdata':
            ensure => present,
            before => File['/etc/localtime'],
        }
        file { '/etc/sysconfig/clock':
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('timezone/el.erb'),
        }
    }
    'Suse': {
        package { 'timezone':
            ensure => present,
            before => File['/etc/localtime'],
        }
        file { '/etc/sysconfig/clock':
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('timezone/suse.erb'),
        }
    }
    'Linux': {
      case $::operatingsystem {
        'Gentoo': {
          package { 'sys-libs/timezone-data':
            ensure => present,
            before => File['/etc/localtime'],
          }
          file { '/etc/conf.d/hwclock':
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('timezone/gentoo.erb'),
          }
        }
        default: {
            fail("The OS ${::operatingsystem} is not supported by this module.")
        }
      }
    }
    default: {
        fail("The OS family ${::osfamily} is not supported by this module.")
    }
  }
}
