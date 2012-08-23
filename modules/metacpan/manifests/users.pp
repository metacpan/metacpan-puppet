class metacpan::users {
    
    # Make sure sudo file perms are right
    file {
        "/etc/sudoers":
            owner => "root",
            group => "root",
            mode => "440";
        "/etc/sudoers.d/README":
            owner => "root",
            group => "root",
            mode => "440",
        
    }
    
    
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

            # Where perl lives
            $export_path = "export PATH=${perlbin}:\$PATH"

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
                            "$moduleserver/metacpan/default/$path/$user/bin",
                            "$moduleserver/metacpan/default/$path/default/bin",
                    ];

                # Create dir for CPAN
                "$path/$user/CPAN":
                    ensure => directory,
                    owner => "$user",
                    group => "$user";

                # Little RC file to setup the env

                "$path/$user/.metacpanrc":
                    owner   => "$user",
                    group   => "$user",
                    mode    => 0700,
                    content => $export_path;
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
                        "$moduleserver/metacpan/nodes/$hostname/$path/$user/ssh/authorized_keys",
                        "$moduleserver/metacpan/location/$location/$path/$user/ssh/authorized_keys",
                        "$moduleserver/metacpan/default/$path/$user/ssh/authorized_keys"
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

}

class metacpan::users::admins inherits metacpan::users {

    metacpanadminuser {
        leo_user:
            user => 'leo', fullname => 'Leo Lapworth', path => '/home';
        clinton_user:
            user => 'clinton', fullname => 'Clinton Gormley', path => '/home';
        mo_user:
            user => 'mo', fullname => 'Moritz Onken', path => '/home';
        olaf_user:
            user => 'olaf', fullname => 'Olaf Alders', path => '/home';
        rafl_user:
            user => 'rafl', fullname => 'Florian Ragwitz', path => '/home',
            shell => '/bin/zsh';
        apeiron_user:
            user => 'apeiron', fullname => 'Chris Nehren', path => '/home',
    }
}

class metacpan::users::basic inherits metacpan::users {

    metacpanuser {
        metacpan:
            user => 'metacpan', fullname => '', path => '/home';
    }

}

