class metacpan::system::postgress {

    # Install postgress
	class { 'postgresql::server': }
}
