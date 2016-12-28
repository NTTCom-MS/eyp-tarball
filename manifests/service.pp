class tarball::service inherits tarball {

  #
  validate_bool($tarball::manage_docker_service)
  validate_bool($tarball::manage_service)
  validate_bool($tarball::service_enable)

  validate_re($tarball::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${tarball::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $tarball::manage_docker_service)
  {
    if($tarball::manage_service)
    {
      service { $tarball::params::service_name:
        ensure => $tarball::service_ensure,
        enable => $tarball::service_enable,
      }
    }
  }
}
