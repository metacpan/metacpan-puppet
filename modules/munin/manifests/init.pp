$default_munin_plugin_path = "/usr/lib/munin/plugins"
$metacpan_munin_plugin_path = "/etc/metacpan/munin/plugins"
$munin_plugin_path = "/etc/munin/plugins"

class munin-node {
    package { "munin-node": ensure => present }
        
    file { "/etc/munin":
        ensure => directory,
        owner   => "root",
        group   => "root",
        mode    => 755,
    }
        
    file { "/etc/munin/munin-node.conf":
        owner  => "root",
        group  => "root",
        mode   => 644,
        source => "$moduleserver/munin/munin-node.conf",
        alias  => "munin-node.conf",
    }
    
    # make sure it's running and reloads when the config files change
    service { munin-node:
        ensure    => running,
        require   => Package["munin-node"],
        subscribe => [ File["munin-node.conf"] ],
    }

    file {
        "$munin_plugin_path":
            ensure  => "directory",
            owner   => "root",
            group   => "root",
            checksum    => mtime,
            require     => Package[munin-node],
            # FIXME: Does not seem to get activated when dir
            # changes from an update
            # notify      => Exec["munin-node-restart"];
            # notify      => Service["munin-node"];
    }

    # Our specifically added plugins
    file {
        "/etc/metacpan/munin":
            ensure  => "directory",
            owner   => "root",
            group   => "root",
            require => [ File["/etc/metacpan"] ];
            
        "$metacpan_munin_plugin_path":
            ensure  => "directory",
            owner   => "root",
            group   => "root",
            recurse => true,
            source => "$moduleserver/munin/plugins"
            # FIXME: Does not seem to get activated when dir
            # changes from an update
            # notify      => Exec["munin-node-restart"];
            # notify      => Service["munin-node"];
    }

  	define add_default_plugin () {
        file {
            "$munin_plugin_path/${name}":
                ensure => link,
                target => "$default_munin_plugin_path/${name}";
        }
    }

  	define add_default_plugin_with_arg (
  	    $type = '',
  	    $arg = ''
    ) {
        file {
            "$munin_plugin_path/${type}${arg}":
                ensure => link,
                target => "$default_munin_plugin_path/${type}";
        }
    }

  	define add_metacpan_plugin () {
        file {
            "$munin_plugin_path/${name}":
                ensure => link,
                target => "$metacpan_munin_plugin_path/${name}";
        }
    }


    define remove_plugin () {
        file {
            "$munin_plugin_path/${name}":
                ensure => absent
        }    
    }
    
    # need to restart munin-node to load new plugins
    exec { "munin-node-restart":
        command     => "/etc/init.d/munin-node restart",
        refreshonly => true,
        before      => Service["munin-node"],
    }

}

class munin::default inherits munin-node {

    munin-node::add_default_plugin {
        [
        "cpu", 
        "df", "df_inode", "diskstats", 
        "fw_packets", 
        "forks", "interrupts", 
        "iostat_ios", "iostat", 
        "irqstats", "load", "memory", 
        "netstat", "open_inodes", "proc_pri", 
        "processes", "swap", "threads", 
        "uptime", "users", "multimemory"
        ]:     
    }

    # If you wanted to specify args could do:
    # munin-node::add_default_plugin_with_arg {
    #     "if_eth2":
    #         type => 'if_',
    #         arg => 'eth2'
    # }
}

class munin::web inherits munin-node {

    # usual stuff
    include munin::default

    munin-node::add_default_plugin {
        [
        "http_loadtime",
        "nginx_status",
        "nginx_request"
        ]:     
    }
    
    munin-node::add_metacpan_plugin {
        [
        "elasticsearch_cache"         ,
        "elasticsearch_cluster_shards",
        "elasticsearch_docs"          ,
        "elasticsearch_index_size"    ,
        "elasticsearch_jvm_memory"    ,
        "elasticsearch_jvm_threads"   ,
        "elasticsearch_open_files"    ,
        "elasticsearch_translog_size" ,
        "starman_processes"           ,
        ]:
    }
    
}




class munin-server {
    package { "munin": ensure => installed }
    package { "telnet": ensure => installed }
    package { "libdate-manip-perl": ensure => installed }
    
    # give munin user & web group permission to generate html and graphs
    # file { "/var/www":
    #     ensure  => directory,
    #     owner   => "munin",
    #     group   => "web",
    #     mode    => 775,
    # }
    # 
    # file { "/var/www/cgi-bin":
    #     ensure  => link,
    #     owner   => "munin",
    #     group   => "web",
    #     mode    => 755,
    #     target  => "/usr/lib/cgi-bin",
    # }
    # 
    # file { "/usr/lib/cgi-bin/munin-cgi-graph":
    #     owner   => "root",
    #     group   => "root",
    #     mode    => 755,
    # }
    # 
    # file { "/usr/share/munin/munin-graph":
    #     owner   => "root",
    #     group   => "web",
    #     mode    => 755,
    # }
    # 
    # file { "/var/log/munin":
    #     ensure => directory,
    #     owner  => "munin",
    #     group  => "web",
    #     mode   => 770,
    # }
    # 
    # file { "/var/log/munin/munin-graph.log":
    #     owner  => "munin",
    #     group  => "web",
    #     mode   => 660,
    # }
    # 
    # file { "/etc/logrotate.d/munin":
    #     owner   => "root",
    #     group   => "root",
    #     mode    => 644,
    #     source  => "$moduleserver/munin/logrotate.d/munin",
    # }
    # 
    # # it's not a service, runs from cron
    # file { "/etc/munin/munin.conf":
    #     owner   => "root",
    #     group   => "root",
    #     mode    => 644,
    #     source  => "$moduleserver/munin/munin.conf",
    #     alias   => "munin.conf",
    #     require => Package["munin"],
    # }
}
