/*
 * compile lib gmime
 * 
 */
class dbmail::dbmail2::compilegmime(
  
) {
  file {'/usr/src/packages/gmime-2.2.27.tar.gz':
    ensure => present,
    source => "puppet:///modules/dbmail/gmime-2.2.27.tar.gz",
    require => Package['pkg-config','libglib2.0-dev']       
  }
  
  exec {'untar_gmime_src':
    command => "/bin/tar -xf gmime-2.2.27.tar.gz",
    cwd     => "/usr/src/packages/",
    creates => "/usr/src/packages/gmime-2.2.27",
    require => File["/usr/src/packages/gmime-2.2.27.tar.gz"]
  }  

  exec {'configure_gmime_src':
    cwd     => "/usr/src/packages/gmime-2.2.27",
    command => "/usr/src/packages/gmime-2.2.27/configure",
    creates => "/usr/src/packages/gmime-2.2.27/config.status",
    require => [Exec['untar_gmime_src']],
    path    => ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"]
  }

  exec {'make_gmime_src':
    cwd     => "/usr/src/packages/gmime-2.2.27",
    command => "/usr/bin/make all",
    creates => "/usr/src/packages/gmime-2.2.27/gmime/libgmime-2.0.la",
    require => [Exec['configure_gmime_src']],
    path    => ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"]
  }
  
  exec {'install_gmime_src':
    cwd     => "/usr/src/packages/gmime-2.2.27",
    command => "/usr/bin/make install",
    creates => "/usr/local/lib/libgmime-2.0.so.2.2.27",
    require => [Exec['configure_gmime_src']],
    path    => ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"]
  }      
}