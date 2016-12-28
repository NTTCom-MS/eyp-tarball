# tarball

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What tarball affects](#what-tarball-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with tarball](#beginning-with-tarball)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)
    * [TODO](#todo)
    * [Contributing](#contributing)

## Overview

tar.gz deployment

## Module Description

This module allows you to manage .tar.gz file deployments

## Setup

### What tarball affects

* extracts a given file to a directory

### Setup Requirements

This module requires pluginsync enabled and the following binaries in your system:
* wget (to download files using **source_url**)
* tar (to be able to extract tar files)

### Beginning with tarball

puppet bucket:

```puppet
tarball::untar { 'tomcat':
  source  => 'puppet:///solr/apache-tomcat-7.0.62.tar.gz',
  ln      => '/tomcat',
  ln_file => 'apache-tomcat-7.0.62',
}
```

URL:

```puppet
tarball::untar { 'tomcat8':
  source_url  => 'http://apache.uvigo.es/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz',
  ln          => '/tomcat8',
  ln_file     => 'apache-tomcat-8.5.9',
}
```

## Usage

```puppet
tarball::untar { 'example':
  basedir     => '/opt',
  filetype    => 'tar',
  srcdir      => '/usr/local/src',
  source_url  => 'http://apache.uvigo.es/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz',
  ln          => '/tomcat8',
  ln_file     => 'apache-tomcat-8.5.9',
}
```

This will download using wget from **source_url** to a file called **srcdir**/**packagename**.**filetype** and extract it to **basedir**/**packagename**. Once extracted, it will create a link on **ln** pointing to **basedir**/**packagename**/**ln_file**

## Reference

### tarball::untar
 * **basedir**: Where to deploy this file (default: /opt)
 * **packagename**: Package name (default: $name)
 * **filetype**: File type, currently only tar is supported (default: tar)
 * **srcdir**: Where to store the downloaded file (default: /usr/local/src)
 * **source_url**: Download using a URL (default: undef)
 * **source**: Extract using a puppet bucket (default: undef)
 * **ln**: Optionally, create a softlink (default: undef)
 * **ln_file**: Softlink's target (default: undef, softlink target will be **basedir**/**packagename**)

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature

### TODO

* zip support

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
