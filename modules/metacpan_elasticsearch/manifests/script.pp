define metacpan_elasticsearch::script(
	$a_value
) {

  elasticsearch::script { $name:
      source  => "puppet:///modules/metacpan_elasticsearch/etc/scripts/${name}.groovy",
  }

}