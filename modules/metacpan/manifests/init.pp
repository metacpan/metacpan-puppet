class metacpan {
    
    # Load in, some of these do stuff, some just mean you
    # can use the sub class from 
    include metacpan::ssh
    include metacpan::configs
    include metacpan::users
    include metacpan::cron
    include metacpan::perl
    
}

class metacpan::rc_files {
    

    rc_d{
        "/tmp/a_file":
    }

    define rc_d() {

        # $rc = "/etc/init.d/$name"
        # 
        file{
            "$name":
                owner => root,
                group => root,
                mode => 0755,
                content => template("metacpan/rc.erb");
        }

        # exec {
        #     "update-rc-$name":
        #         command => "/usr/sbin/update-rc.d $name defaults 18",
        #         creates => "/etc/rc2.d/S18$name";
        # }



    }
    
}




