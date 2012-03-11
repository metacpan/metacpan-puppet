Repo for metacpan server puppet configurations

OpenSuse:

# Installing
    zypper in puppet-server

Should get you puppet-0.25.4-4.7.1.x86_64

# Setup
    cd /etc
    rm -rf puppet
    git clone git://github.com/CPAN-API/Metacpan-Puppet.git ./puppet


# To Delete
--- NOTES (should be able to ignore shortly, this is just incase)

Note:
If you've set the 'certdnsnames' option in your master's
puppet.conf file, merely installing the updated packages is not
sufficient to fix this problem. You need to either pick a new DNS
name for the master and reconfigure all agents to use it or re-new
certificates on all agents.

Please refer to the documentation in
/usr/share/doc/packages/puppet/puppetlabs-cve20113872-0.0.5
for detailed instructions and scripts.

Puppetlabs' site also provides more information:
http://puppetlabs.com/security/cve/cve-2011-3872/faq/
http://puppetlabs.com/blog/important-security-announcement-altnames-vulnerability/
