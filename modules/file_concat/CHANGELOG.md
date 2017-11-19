##0.3.0 ( Mar 26, 2015 )

###Summary
This release adds windows support to the library.

####Features
* Added windows support to the library.

####Bugfixes

####Changes

####Testing changes

####Known bugs

##0.2.1 ( Mar 25, 2015 )

###Summary
Bugfix release

####Features

####Bugfixes
* Fix a bug caused by some refactoring

####Changes

####Testing changes

####Known bugs
* Windows is not supported yet

##0.2.0 ( Mar 25, 2015 )

###Summary
With this release Ive done several code cleanups and added some basic tests.
Also support for puppet-server has been fixed

####Features

####Bugfixes
* Remove unnecessary require which fixed support for puppet-server

####Changes
* Added some basic files
* Implemented rubocop for style checking

####Testing changes
* Implemented basic acceptance tests

####Known bugs
* Windows is not supported yet

##0.1.0 ( Jan 21, 2014 )
  Rewrite of the fragment ordering part.
    Fragments are now first ordered based on the order number and then on the resource name.
  Convert `order` parameter to string to support integer values when using Hiera/YAML ( PR#3 by Michael G. Noll )

##0.0.2 ( Mar 03, 2013 )
  Adding source variable option to file_fragment type

##0.0.1 ( Jan 13, 2013 )
  Initial release of the module
