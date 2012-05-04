$fileserver = 'puppet://localhost/files'
$moduleserver = 'puppet://localhost'

# import 'modules.pp'
import 'classes/*.pp'

# Modules
import "munin"
import "metacpan"

# Needs to be include to get the environment stuff working
include "perlbrew"


import "nodes"