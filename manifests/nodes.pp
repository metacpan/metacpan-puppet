# Setup all machines the same (for now at least)

$perlbrew_ = 'export PATH=/usr/local/perlbrew/perls/metalib/bin:$PATH'

# Stuff every node should get
include puppet::client

import "nodes/*.pp"
