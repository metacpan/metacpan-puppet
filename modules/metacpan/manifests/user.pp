define metacpan::user(
    $ensure = present,
    $user = $name,
    $fullname = "",
    $path = "/home",
    $shell = "/bin/bash",
    $admin = false,
    $expire_password = true,
    $no_passwd_sudo = false,
    $ssh_dir = true,
    $bin_dir = false,
) {

  # This could be done better, but works for now!
  if $ensure == 'present' {

      user { $user:
          home       => "$path/$user",
          managehome => true,
          ensure     => $ensure,
          comment    => "$fullname",
          shell      => "$shell",
          provider   => "useradd",
          groups     => [ "shellaccess" ],
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

      if $bin_dir {

        # Set up user
        file {
            # Copy the whole of the user's bin dir
            "$path/$user/bin":
                ensure  => directory,
                require => User[$user],
                recurse => true,
                owner   => $user,
                group   => $user,
                mode    => '0755', # make everything executable
                source  => [
                        "puppet:///modules/metacpan/default/$path/$user/bin",
                        "puppet:///modules/metacpan/default/$path/default/bin",
                ];
        }

        # Add to BASH, perl version hard coded :(
        line { "/home/$user/.bashrc":
          ensure  => present,
          line    => 'PATH=/opt/perl-5.22.2/bin:$PATH',
          require => User[$user],
        }
      }

      if $ssh_dir {

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
              mode  => 0600,
              source => [
                      "puppet:///modules/metacpan/nodes/$hostname/$path/$user/ssh/authorized_keys",
                      "puppet:///modules/metacpan/location/$location/$path/$user/ssh/authorized_keys",
                      "puppet:///modules/metacpan/default/$path/$user/ssh/authorized_keys"
                      ],
          }
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
  } else {

    # Remove the user and their home dir
    user { $user:
        home       => "$path/$user",
        managehome => true,
        ensure     => $ensure,
        comment    => "$fullname",
        shell      => "$shell",
        provider   => "useradd",
    }

    # Also remove the sudoers
    file {
      "/etc/sudoers.d/$user":
        ensure => $ensure,
    }
  }
}
