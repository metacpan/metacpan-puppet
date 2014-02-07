define metacpan::user(
    $user = $name,
    $fullname = "",
    $path = "/home",
    $shell = "/bin/bash",
    $admin = false,
    $expire_password = true,
    $source_metacpanrc = false,
) {

    user { $user:
        home       => "$path/$user",
        managehome => true,
        ensure     => "present",
        comment    => "$fullname",
        shell      => "$shell",
        provider   => "useradd",
    }->
    # force empty password
    # setting password => "" above will result
    # in a locked user account in the first run
    # puppet bug?
    exec { "usermod --password '' $user":
        path        => "/usr/sbin",
        subscribe   => User[$user],
        refreshonly => true,
    }

    if $expire_password {
        # force user to set password on first login
        exec { "chage -d 0 $user":
            path        => "/usr/bin",
            subscribe   => User[$user],
            refreshonly => true,
            require     => Exec["usermod --password '$password' $user"],
        }
    }

    # Set up user
    file {
        # Copy the whole of the users bin dir
        "$path/$user/bin":
            ensure  => directory,
            require => User[$user],
            recurse => true,
            owner   => $user,
            group   => $user,
            mode    => '0700', # make everything executible
            source  => [
                    "puppet:///modules/metacpan/default/$path/$user/bin",
                    "puppet:///modules/metacpan/default/$path/default/bin",
            ];

        # Little RC file to setup the env

        "$path/$user/.metacpanrc":
            owner   => $user,
            group   => $user,
            mode    => 0700,
            content => template("metacpan/user/metacpanrc.erb");
    }

    if $source_metacpanrc {
      # Turn "/bin/(bash|zsh)" into "/home/$user/.${1}rc".
      $shell_rc_file = regsubst($shell, '^(?:.+?/)?([^/]+)$', "$path/$user/.\\1rc")
      line { $shell_rc_file:
        ensure  => present,
        line    => "source $path/$user/.metacpanrc",
        require => User[$user],
      }
    }

    # Sort out ssh file, need dir first
    file{ "$path/$user/.ssh":
        owner  => $user,
        group  => $user,
        mode   => 0700,
        ensure => directory,
    }->
    file { "$path/$user/.ssh/authorized_keys":
        owner => $user,
        group => $user,
        mode  => 600,
        source => [
                "puppet:///modules/metacpan/nodes/$hostname/$path/$user/ssh/authorized_keys",
                "puppet:///modules/metacpan/location/$location/$path/$user/ssh/authorized_keys",
                "puppet:///modules/metacpan/default/$path/$user/ssh/authorized_keys"
                ],
    }

    if($admin) {
        # Also add to sudoers
        file {
          "/etc/sudoers.d/$user":
            owner => "root",
            group => "root",
            mode => "440",
            content => "$user   ALL = (ALL) ALL";
        }
    }
}


class metacpan::user::admins {
    package { zsh: ensure => present } # for rafl
    package { byobu: ensure => present } # for mo
    package { tmux:  ensure => present } # for rwstauner
    metacpan::user {
        leo:
            admin    => true,
            fullname => "Leo Lapworth <leo@cuckoo.org>";
        clinton:
            admin    => true,
            fullname => "Clinton Gormley <clint@traveljury.com>";
        mo:
            admin    => true,
            fullname => "Moritz Onken <onken@netcubed.de>",
            require  => Package["byobu"];
        olaf:
            admin    => true,
            source_metacpanrc => true,
            fullname => "Olaf Alders <olaf.alders@gmail.com>";
        rafl:
            admin    => true,
            fullname => "Florian Ragwitz <rafl@perldition.org>",
            shell    => "/bin/zsh",
            require  => Package["zsh"];
        apeiron:
            admin    => true,
            fullname => "Chris Nehren";
        rwstauner:
            admin    => true,
            source_metacpanrc => true,
            fullname => "Randy Stauner";
        trs:
            admin    => true,
            source_metacpanrc => true,
            fullname => "Thomas Sibley <tsibley@cpan.org>";
    }
}

