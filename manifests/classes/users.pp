define metacpanuser( $user, $fullname, $path, $shell = '/bin/bash' ) {

        # # clear out the group first
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
        file { "$path/$user":
                owner => "$user",
                group => "$user",
                ensure => directory
        }
        # # Sort out web auth file, need dir first
        # file{ "$path/$user/.ssh":
        #         owner => "$user",
        #         group => "$user",
        #         mode => 0700,
        #         ensure => directory,
        # }
        # file { "$path/$user/.ssh/authorized_keys2":
        #         owner => "$user",
        #         group => "$user",
        #         mode => 600,
        #         source => [
        #                 "$fileserver/nodes/$hostname/$path/$user/ssh/authorized_keys2",
        #                 "$fileserver/location/$location/$path/$user/ssh/authorized_keys2",
        #                 "$fileserver/default/$path/$user/ssh/authorized_keys2"
        #                 ],
        # }
}