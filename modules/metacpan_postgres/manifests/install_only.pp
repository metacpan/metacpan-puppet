class metacpan_postgres::install_only(
  ) {

    # Install postgres
    class { 'postgresql::globals':
                 manage_package_repo => true,
                 version             => '9.6',
        }->class { 'postgresql::server':
          listen_addresses => '*',
          service_ensure => 'stopped',
          service_enable => 'false',
        }
}
