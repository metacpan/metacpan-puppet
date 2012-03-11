class s_mcp {
    $access_extra += [ "mcp" ]
    $vhosts = ["metacpan.org", "api.metacpan.org", "cpan.metacpan.org"]
    $ha_nodes = ["mcp-1"]
    $ha_resources = ["mcp-1 IPaddr::10.43.1.202"]

    include elasticsearch
    include fail2ban
#    include heartbeat
    include kvm
    include nginx
    include base::common

    lvm::volume{"/var/lib/elasticsearch":
        lv => "elasticsearch",
        size => "90G",
        require => Package["elasticsearch"],
        before => Service["elasticsearch"],
        owner => elasticsearch,
        group => elasticsearch,
    }
    lvm::volume{"/srv/cpan":
        lv => "cpan",
        size => "40G",
        owner => metacpan,
        group => metacpan,
        require => User["metacpan"],
    }
    lvm::volume{"/srv/metacpan":
        lv => "metacpan",
        size => "5G",
        owner => metacpan,
        group => metacpan,
        mode => 0775,
        require => User["metacpan"],
    }
    group{"metacpan":
        gid => 500,
    }
    user{"metacpan":
        uid => 500,
        gid => 500,
        shell => "/bin/bash",
        home => "/srv/metacpan",
    }

    package{["libxml2-devel"]:
    }
}
