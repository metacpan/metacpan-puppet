$fileserver = 'puppet://localhost/files'
$moduleserver = 'puppet://localhost'

import 'modules.pp'
import 'classes/*.pp'

include 'perlbrew'

case $operatingsystem {
  Debian: {
    Package{ provider => apt }
  }
  default: {
    Package{ provider => apt }
  }
}

node localhost {
    # Setup all machines the same (for now at least)
    include default_setup

    include munin::web
    include munin-server

    $vhosts = [
    "api.metacpan.org", "metacpan.org",
    "sco.metacpan.org", "cpan.metacpan.org", "js.metacpan.org",
    "contest.metacpan.org",
    "munin",
    ]
    include nginx

    # PERL INSTALLS - THIS SHOULD BE SPLIT OUT LATER
    
    # cpan-api
    perlbrew::build { "cpan-api": version => "5.14.2" }
    perlbrew::install_cpanm {
        "cpan-api":
    }
    $cpan_api_modules = ["Data::Pageset"]    
    # perlbrew::install_modules {
    #     'cpan-api-modules':
    #         perl => "cpan-api",
    #         toinstall => $cpan_api_modules,
    # }
    
    # metacpan-web
    perlbrew::build { "metacpan-web": version => "5.14.2" }
    perlbrew::install_cpanm {
        "metacpan-web":
    }
    
    # We can't use this atm because:
    # Duplicate definition: Perlbrew::Install_module[Data::Pageset]"

    $metacpan_web_modules = ["Data::Pageset","DateTime"]    
    # perlbrew::install_modules {
    #     'metacpan-web-modules':
    #         perl => "metacpan-web",
    #         toinstall => $metacpan_web_modules,
    # }
    
    
    
    
    
    

}
