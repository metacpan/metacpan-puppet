$fileserver = "puppet://localhost:9100/files"
$moduleserver = "puppet://localhost:9100"

# import "modules.pp"
# import "../classes/*.pp"

class base_files {
    file { "/tmp/leo_testing.txt":
            owner => "root",
            group => "root",
            mode => 440,
            source => "$fileserver/default/tmp/leo_test.txt",
    }
}
node localhost {
    # Setup all machines the same (for now at least)
    include base_files
    
}

