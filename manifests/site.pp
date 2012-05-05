$fileserver = 'puppet://localhost/files'
$moduleserver = 'puppet://localhost'

# Modules
import "munin"
import "logrotate"
import "metacpan"

# Needs to be include to get the environment stuff working
include "perlbrew"

import "nodes"