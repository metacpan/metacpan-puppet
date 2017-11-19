# Puppet Timezone Module #

A very basic Puppet module to set the timezone properly.  Works on
RHEL/CentOS, Amazon Linux, SUSE, Debian, Ubuntu and Gentoo.

Requires >= Puppet 3.2.0 on Debian and Ubuntu because of a Puppet bug
and the way timezone files have been laid out on disk.
Works with Puppet 2.7+ on other distros.

## Usage ##

In your manifest:
```puppet
class { 'timezone':
  region   => 'Europe',
  locality => 'London',
}
```
Or you can simply include timezone and set the details via hiera:
```yaml
timezone::region: 'Europe'
timezone::locality: 'London'
```

## License

Simplified BSD License
