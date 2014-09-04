define metacpan::user(
    $user = $name,
    $fullname = "",
    $path = "/home",
    $shell = "/bin/bash",
    $admin = false,
    $expire_password = true,
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

    if( $user == 'metacpan') {

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
            fullname => "Olaf Alders <olaf.alders@gmail.com>";
        rafl:
            admin    => true,
            fullname => "Florian Ragwitz <rafl@perldition.org>",
            shell    => "/bin/zsh",
            require  => Package["zsh"];
        rwstauner:
            admin    => true,
            shell    => '/bin/zsh',
            require  => Package['zsh'],
            fullname => 'Randy Stauner <rwstauner@cpan.org>';
        trs:
            admin    => true,
            fullname => "Thomas Sibley <tsibley@cpan.org>";
        matthewt:
            admin    => true,
            fullname => "Matt S Trout <perl-stuff@trout.me.uk>";
        haarg:
            admin    => true,
            fullname => "Graham Knop <haarg@haarg.org>";
	mhorsfall:
            admin    => true,
            fullname => "Matthew Horsfall (alh) <wolfsage@gmail.com>";
        ben:
            admin    => true,
            fullname => "Ben Hundley <ben@qbox.io>";
    }
}
