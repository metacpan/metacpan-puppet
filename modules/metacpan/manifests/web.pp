# Variour bits that don't fit into hiera yet
class metacpan::web {

	file { '/home/metacpan/metacpan.org/root/static/sitemaps':
			ensure => directory,
			owner => 'metacpan',
			group => 'metacpan',
	}

}
