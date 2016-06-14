# Install Carton for project dependencies.
class carton() {

  perl::module{ 'Carton':
  	version => 'v1.0.22'
  }

}
