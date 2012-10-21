class metacpan::exim {
    package { "exim4-daemon-light":
        ensure => installed,
    }->
    service { "exim4":
        ensure => running,
        enable => true,
    }
    line { "exim4_comment":
        file => "/etc/exim4/update-exim4.conf.conf",
        ensure => comment,
        line => "dc_eximconfig_configtype='\"'\"'local'\"'\"'";

           "exim4_configtype_internet":
        file => "/etc/exim4/update-exim4.conf.conf",
        ensure => present,
        line => "dc_eximconfig_configtype='\"'\"'internet'\"'\"'",
        notify => Service[exim4];
    }
}
