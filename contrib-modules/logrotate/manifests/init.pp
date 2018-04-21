#
class logrotate (
  String $ensure                     = present,
  Boolean $hieramerge                = false,
  Boolean $manage_cron_daily         = true,
  Boolean $create_base_rules         = true,
  Boolean $purge_configdir           = false,
  String $package                    = 'logrotate',
  Hash $rules                        = {},
  Optional[Hash] $config             = undef,
  Integer[0,23] $cron_daily_hour     = $logrotate::params::cron_daily_hour,
  Integer[0,59] $cron_daily_minute   = $logrotate::params::cron_daily_minute,
  Integer[0,59] $cron_hourly_minute  = $logrotate::params::cron_hourly_minute,
  String $cron_hourly_file           = $logrotate::params::cron_hourly_file,
  String $configdir                  = $logrotate::params::configdir,
  String $logrotate_bin              = $logrotate::params::logrotate_bin,
  String $logrotate_conf             = $logrotate::params::logrotate_conf,
  Boolean $manage_package            = $logrotate::params::manage_package,
  String $rules_configdir            = $logrotate::params::rules_configdir,
  String $root_user                  = $logrotate::params::root_user,
  String $root_group                 = $logrotate::params::root_group,
) inherits logrotate::params {

  contain ::logrotate::install
  contain ::logrotate::config
  contain ::logrotate::rules
  contain ::logrotate::defaults

  Class['::logrotate::install']
  -> Class['::logrotate::config']
  -> Class['::logrotate::rules']
  -> Class['::logrotate::defaults']
}
