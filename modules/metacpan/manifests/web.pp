# Various bits that don't fit into hiera yet
class metacpan::web(
		$user = hiera('metacpan::user', 'metacpan'),
		$group = hiera('metacpan::group', 'metacpan'),
) {

	file { "/home/${user}/metacpan-web/root/static/sitemaps":
			ensure => directory,
			owner => $user,
			group => $group,
	}

}
