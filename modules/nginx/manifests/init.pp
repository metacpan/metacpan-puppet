class nginx {
        package { "nginx":
                ensure => installed,
        }->
        file { "/etc/nginx/conf.d/basics.conf":
                source => "puppet:///modules/nginx/basics.conf",
                ensure => file,
        }->

        file { "/etc/logrotate.d/nginx":
                source => "puppet:///modules/nginx/logrotate.conf",
                ensure => file,
        }->

        service { "nginx":
                ensure => running,
        }
}