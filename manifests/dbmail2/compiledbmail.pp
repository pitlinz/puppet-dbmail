/**
 * class compile dbmail
 */
class dbmail::dbmail2::compiledbmail (
  
) {
  file {'/usr/src/packages/dbmail-2.2.18.tar.gz':
    ensure => present,
    source => "puppet:///modules/dbmail/dbmail-2.2.18.tar.gz"
  }

  exec {'untar_dbmail_src':
    command => "/bin/tar -xvzf dbmail-2.2.18.tar.gz",
    cwd     => "/usr/src/packages/",
    creates => "/usr/src/packages/dbmail-2.2.18",
    require => File["/usr/src/packages/dbmail-2.2.18.tar.gz"]
  }

   
   
  exec {'configure_dbmail_src':
    cwd     => "/usr/src/packages/dbmail-2.2.18",
    command => "/usr/src/packages/dbmail-2.2.18/configure --with-sieve=/usr --with-mysql",
    creates => "/usr/src/packages/dbmail-2.2.18/config.status",
    require => [Exec['untar_dbmail_src','install_libzdb_src','install_gmime_src']],
    path    => ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"]
  }
  
  exec {"make_dbmail_src":
    cwd     => "/usr/src/packages/dbmail-2.2.18",
    command => "/usr/bin/make all",
    creates => "/usr/src/packages/dbmail-2.2.18/config.status",
    require => Exec['configure_dbmail_src'],
    path    => ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"]
  }
  
  exec {"install_dbmail_src":
    cwd     => "/usr/src/packages/dbmail-2.2.18",
    command => "/usr/bin/make install",
    creates => "/usr/local/sbin/dbmail-lmtpd",
    require => Exec['configure_dbmail_src'],
    path    => ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"]
  } 
}  
