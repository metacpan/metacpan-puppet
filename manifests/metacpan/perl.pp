class metacpan_perl {
    
    # Packages we need to build stuff
    package { 
        # for https
        'libssl-dev': ensure => present;
        # for gzip
        'zlib1g-dev': ensure => present;
        # for Test::XPath 
        'libxml2-dev': ensure => present;
        # for XML::Parser (used by Test::XPath)
        'libexpat1-dev': ensure => present;        
    }

    # install the perl
    perlbrew::build { "metalib": version => "5.14.2" }

    # install cpanm
    perlbrew::install_cpanm { "metalib": }

    # list our perl modules
    $cpan_modules = [
        'AnyEvent::HTTP',
        'Archive::Any',
        'Captcha::reCAPTCHA',
        'Catalyst',
        'Catalyst::Action::RenderView',
        'Catalyst::Authentication::Store::Proxy',
        'Catalyst::Controller::ActionRole',
        'Catalyst::Controller::REST',
        'Catalyst::Plugin::Authentication',
        'Catalyst::Plugin::ConfigLoader',
        'Catalyst::Plugin::Session',
        'Catalyst::Plugin::Session::State::Cookie',
        'Catalyst::Plugin::Static::Simple',
        'Catalyst::Plugin::Unicode::Encoding',
        'Catalyst::TraitFor::Request::REST::ForBrowsers',
        'Catalyst::View::JSON',
        'Catalyst::View::TT::Alloy',
        'CatalystX::InjectComponent',
        'CatalystX::RoleApplicator',
        'CHI',
        'Config::General',
        'DateTime::Format::HTTP',
        'DateTime::Format::ISO8601',
        'DBD::SQLite',
        'DBI',
        'Devel::ArgNames',
        'ElasticSearch',
        'ElasticSearchX::Model',
        'Email::Address',
        'Email::Sender::Simple',
        'Encode',
        'EV',
        'File::Find',
        'File::Path',
        'Gravatar::URL',
        'Hash::AsObject',
        'Hash::Merge',
        'HTML::Restrict',
        'HTML::Tree',
        'HTTP::Request::Common',
        'IO::All',
        'IPC::Run3',
        'JSON',
        'JSON::XS',
        'Log::Log4perl::Appender::ScreenColoredLevels',
        'LWP::Protocol::https',
        'Module::Find',
        'MooseX::Attribute::Deflator',
        'MooseX::ChainedAccessors',
        'Mozilla::CA',
        'Parse::CPAN::Packages::Fast',
        'Parse::CSV',
        'Path::Class',
        'PerlIO::gzip',
        'Plack::Middleware::Assets',
        'Plack::Middleware::Header',
        'Plack::Middleware::ReverseProxy',
        'Plack::Middleware::Runtime',
        'Plack::Middleware::ServerStatus::Lite',
        'Plack::Middleware::Session',
        'Pod::Coverage::Moose',
        'Regexp::Common::time',
        'Starman',
        'strictures',
        'Template::Alloy',
        'Template::Plugin::JSON',
        'Template::Plugin::Markdown',
        'Template::Plugin::Number::Format',
        'Template::Plugin::Page',
        'Test::More',
        'Test::XPath',
        'Try::Tiny',
        'WWW::Mechanize::Cached',
        'XML::Feed',
        'YAML',
    ]
    # install our perl modules
    # use perlbrew::install_no_test_module if you dont' want to run tests
    perlbrew::install_module {
        $cpan_modules:
            perl => 'metalib';
    }
}



