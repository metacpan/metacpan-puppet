define rrrclient::cron(
  $ensure = absent,
  $cpan_mirror,
  $user = hiera('metacpan::user', 'metacpan'),
  $rrr_server = hiera('metacpan::rrrclient::server'),
) {

    # BARBIE pointed out an issue where rrr_client misses arbitrary uploads. He and
    # ANDK have not been able to pinpoint the problem.  It's rare, but a restart of
    # the rrr-client causes it to pick up missed uploads.  It's possible that this
    # is the source of some of the issues we have with dists which are a) not
    # indexed and b) index cleanly once we trigger a manual indexing
    cron {
      'metacpan_restart_rrr_client':
          user        => 'root',
          command     => '/etc/init.d/rrrclient-metacpan restart > /tmp/restart-rrrclient.txt 2>&1',
          environment => [
            # On start-stop-daemon is in /sbin.
            'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          ],
          hour        => '3',
          minute      => '30',
          ensure      => $ensure;
    }

    # Catch up with any files we might have missed.
    # Another job should find any unindexed releases this gets and index them.
    # http://www.cpan.org/misc/how-to-mirror.html#rsync
    cron {
      'metacpan_daily_rsync':
          user        => $user,
          # NOTE: No "--delete" arg since we're also a backpan.
          command     => "/usr/bin/rsync -a ${rrr_server}::CPAN ${cpan_mirror}",
          hour        => '23',
          minute      => '13',
          ensure      => $ensure;
    }
}
