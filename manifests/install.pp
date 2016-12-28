class tarball::install inherits tarball {

  if($tarball::manage_package)
  {
    package { $tarball::params::package_name:
      ensure => $tarball::package_ensure,
    }
  }

}
