#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin); # core

my $in  = get_fh('<', "$Bin/../init.sh");
my $out_path = "$Bin/init-for-vagrant.sh";
my $out = get_fh('>', $out_path);

while(<$in>){
  # don't warn and no-op; actually stop them from running
  s{^(update-rc\.d) -n (\S+) remove}{$1 $2 disable; /etc/init.d/$2 stop};

  # instead of git clone (since we already have it checked out) just copy it
  # copy (as opposed to symlink) so that the owner and perms get set right
  s{^git clone .+/Metacpan-Puppet(?:\.git)? (\S+)}{\ncp -r /vagrant $1};

  print $out $_;
}

close $out;
chmod 0755, $out_path;

sub get_fh {
  my ($dir, $path) = @_;
  open my $fh, $dir, $path
    or die "failed to open $dir $path: $!";
  return $fh;
}
