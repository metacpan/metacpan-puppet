# Various bits that don't fit into hiera yet
class metacpan::web(
		$user = hiera('metacpan::user', 'metacpan'),
		$group = hiera('metacpan::group', 'metacpan'),
) {

}
