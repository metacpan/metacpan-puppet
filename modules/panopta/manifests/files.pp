class panopta::files() {

  # get package list
  file{
    "/etc/apt/sources.list.d/panopta.list":
    content => "deb http://packages.panopta.com/deb stable main";
  }

}
