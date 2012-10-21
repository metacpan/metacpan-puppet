define metacpan::user(
    $user = $name,
    $fullname = "",
    $path = "/home",
    $shell = "/bin/bash",
    $admin = false,
) {

    # clear out the group first
    group { $user:
        name      => $user,
        ensure    => "present",
        provider  => "groupadd",
    }

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
    }->
    # force user to set password on first login
    exec { "chage -d 0 $user":
        path        => "/usr/bin",
        subscribe   => User[$user],
        refreshonly => true,
    }

    # Where perl lives
    $export_path = "export PATH=${perlbin}:\$PATH"

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
                    "$moduleserver/metacpan/default/$path/$user/bin",
                    "$moduleserver/metacpan/default/$path/default/bin",
            ];

        # Little RC file to setup the env

        "$path/$user/.metacpanrc":
            owner   => $user,
            group   => $user,
            mode    => 0700,
            content => $export_path;
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
                "$moduleserver/metacpan/nodes/$hostname/$path/$user/ssh/authorized_keys",
                "$moduleserver/metacpan/location/$location/$path/$user/ssh/authorized_keys",
                "$moduleserver/metacpan/default/$path/$user/ssh/authorized_keys"
                ],
    }

    if($admin) {
        # Also add to sudoers
        file {
          "/etc/sudoers.d/$user":
            owner => "root",
            group => "root",
            mode => "440",
            content => "$user   ALL = ALL";
        }
    }
}


class metacpan::user::admins {
    metacpan::user {
        leo:
            admin    => true,
            fullname => "Leo Lapworth <leo@cuckoo.org>";
        clinton:
            admin    => true,
            fullname => "Clinton Gormley <clint@traveljury.com>";
        mo:
            admin    => true,
            fullname => "Moritz Onken <onken@netcubed.de>";
        olaf:
            admin    => true,
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
            fullname => "Randy Stauner";
    }
}

