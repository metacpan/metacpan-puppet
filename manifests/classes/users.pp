define metacpanuser( $user, $fullname, $path, $shell = '/bin/bash' ) {

        # clear out the group first
        group { "$user":
                name      => "$user",
                ensure    => "present",
                provider  => "groupadd",
        }

        user { "$user":
                home => "$path/$user",
                ensure     => "present",
                comment    => "$fullname",
                shell      => "$shell",
                gid        => "$user",
                provider   => "useradd",
                # password   => "$password",
                # groups     => [ 'user' ]
        }

        # Set up user
        file {
            "$path/$user":
                owner => "$user",
                group => "$user",
                ensure => directory;
                
            # Copy the whole of the users bin dir
            "$path/$user/bin":
                ensure => directory,
                recurse => true,
                owner => "$user",
                group => "$user",
                mode => '0700', # make everything executible
                source => [
                        "$fileserver/default/$path/$user/bin",
                        "$fileserver/default/$path/default/bin",
                ];
        }
}

define metacpanadminuser( $user, $fullname, $path, $shell = '/bin/bash' ) {

    # Create the normal user
    metacpanuser { 
        "admin_$user":
            user => $user, fullname => $fullname, path => $path, shell => $shell;
    }

    # Sort out ssh file, need dir first
    file{ "$path/$user/.ssh":
            owner => "$user",
            group => "$user",
            mode => 0700,
            ensure => directory,
    }
    file { "$path/$user/.ssh/authorized_keys":
            owner => "$user",
            group => "$user",
            mode => 600,
            source => [
                    "$fileserver/nodes/$hostname/$path/$user/ssh/authorized_keys",
                    "$fileserver/location/$location/$path/$user/ssh/authorized_keys",
                    "$fileserver/default/$path/$user/ssh/authorized_keys"
                    ],
    }

    # Also add to sudoers
    file {
        "/etc/sudoers.d/$user":
            owner => "root",
            group => "root",
            mode => "440",
            content => "$user   ALL = ALL";
    }

}