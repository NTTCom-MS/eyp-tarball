define tarball::untar (
                        $basedir     = '/opt',
                        $packagename = $name,
                        $filetype    = 'tar',
                        $srcdir      = '/usr/local/src',
                        $source_url  = undef,
                        $source      = undef,
                        $ln          = undef,
                        $ln_file     = undef,
                      ) {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  if($source_url==undef and $source==undef)
  {
    fail('source_url or source must be defined')
  }

  if($source_url!=undef and $source!=undef)
  {
    fail('source_url and source cannot be defined at the same time')
  }

  exec { "mkdir ${srcdir} ${packagename}":
    command => "mkdir -p ${srcdir}",
    creates => $srcdir,
  }

  exec { "which wget ${packagename}":
    command => 'which wget',
    unless  => 'which wget',
  }

  if($source_url==undef)
  {
    file { "${srcdir}/${packagename}.${filetype}":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => $source,
      require => Exec["mkdir ${srcdir} ${packagename}"],
      notify  => Exec["extract ${filetype} ${packagename}"],
    }
  }
  else
  {
    exec { "wget ${source_url}":
      command => "wget ${source_url} -O ${srcdir}/${packagename}.${filetype}",
      creates => "${srcdir}/${packagename}.${filetype}",
      require => Exec[ [ "mkdir ${srcdir} ${packagename}", "which wget ${packagename}" ] ],
      notify  => Exec["extract ${filetype} ${packagename}"],
    }

    file { "${srcdir}/${packagename}.${filetype}":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Exec["wget ${source_url}"],
      before  => Exec["extract ${filetype} ${packagename}"],
    }
  }

  case $filetype
  {
    'tar':
    {
      exec { "which tar ${packagename}":
        command => 'which tar',
        unless  => 'which tar',
      }

      exec { "mkdir ${basedir} ${packagename}":
        command => "mkdir -p ${basedir}/${packagename}",
        creates => "${basedir}/${packagename}",
      }

      exec { "extract ${filetype} ${packagename}":
        command     => "tar xf ${srcdir}/${packagename}.${filetype} -C ${basedir}/${packagename}",
        refreshonly => true,
        require     => [
                          Exec[ [ "mkdir ${basedir} ${packagename}", "which tar ${packagename}" ] ],
                          File["${srcdir}/${packagename}.${filetype}"]
                        ],
      }
    }
    default:
    {
      fail("unsupported filetype: ${filetype}")
    }
  }

  if($ln!=undef)
  {
    file { $ln:
      ensure  => 'link',
      target  => "${basedir}/${packagename}/${ln_file}",
      require => Exec["extract ${filetype} ${packagename}"],
    }
  }

}
