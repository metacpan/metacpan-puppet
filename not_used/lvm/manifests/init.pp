class lvm {
    
}

define lvm::volume(
    $lv = "LogVol01",
    $vg = "VolGroup00",
    $size = "",
    $auto_extend = true,
    $owner = "root",
    $group = "root",
    $mode = 0755) {

    file{"$name":
        ensure => directory,
        owner => $owner,
        group => $group,
        mode => $mode,
    }
    exec{"lvcreate-$vg-$lv":
        path      => ['/sbin','/bin','/usr/sbin','/usr/bin'],
        logoutput => false,
        command   => "lvcreate -n $lv -L $size /dev/$vg && mkfs -t ext3 /dev/$vg/$lv",
        unless    => "lvs --noheadings --separator , | grep -q ' $lv,$vg,'",
        require   => File[$name],
    }

    mount{$name:
        atboot    => true,
        device    => "/dev/$vg/$lv",
        ensure    => mounted,
        fstype    => "ext3",
        options   => "defaults",
        dump      => '1',
        pass      => '2',
        require   => [Exec["lvcreate-$vg-$lv"], File[$name]],
    }
    if($auto_extend) {
        exec{"resize-$vg-$lv to $size":
            logoutput => true,
            command   => "lvextend -L$size /dev/$vg/$lv && resize2fs /dev/$vg/$lv",
            unless    => "lvs --noheadings --separator , | sed -e 's/\...G,/G,/' | grep -q ' $lv,$vg,.*,$size,'",
            require   => [Mount[$name]],
        }

    }
}
