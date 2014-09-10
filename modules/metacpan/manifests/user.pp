define metacpan::user(
    $user = $name,
    $fullname = "",
    $path = "/home",
    $shell = "/bin/bash",
    $admin = false,
    $expire_password = true,
    $no_passwd_sudo = false,
) {

    user { $user:
        home       => "$path/$user",
        managehome => true,
        ensure     => "present",
        comment    => "$fullname",
        shell      => "$shell",
        provider   => "useradd",
    }->
    file {
      "$path/$user":
        ensure => directory,
        owner   => $user,
        group   => $user,
    }
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

    if( $user == 'metacpan' or $user == 'vagrant') {

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


    if $admin {

        if $no_passwd_sudo {

          # Also add to sudoers, no password needed
          file {
            "/etc/sudoers.d/$user":
              owner => "root",
              group => "root",
              mode => "440",
              content => "$user  ALL = NOPASSWD: ALL";
          }


        } else {

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
}
