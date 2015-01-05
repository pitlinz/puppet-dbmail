/*
 * compile libzdb
 * 
 * author Peter Krebs <pitlinz@sourceforge.net>
 */
 
class dbmail::dbmail2::compilelibzdb(
  
) {
  file {'/usr/src/packages/libzdb-2.12.tar.gz':
    ensure => present,
    source => "puppet:///modules/dbmail/libzdb-2.12.tar.gz",
    require => Package['flex']
  }  

  exec {'untar_libzdb_src':
    command => "/bin/tar -xzf libzdb-2.12.tar.gz",
    cwd     => "/usr/src/packages/",
    creates => "/usr/src/packages/libzdb-2.12",
    require => File["/usr/src/packages/libzdb-2.12.tar.gz"]
  }

  exec {'configure_libzdb_src':
    cwd     => "/usr/src/packages/libzdb-2.12",
    command => "/usr/src/packages/libzdb-2.12/configure --with-mysql",
    creates => "/usr/src/packages/libzdb-2.12/config.status",
    require => [Exec['untar_libzdb_src'], Package['libmysqlclient-dev']],
    path    => ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"]
  }
  
  exec {'make_libzdb_src':
    cwd     => "/usr/src/packages/libzdb-2.12",
    command => "/usr/bin/make all",
    creates => "/usr/src/packages/libzdb-2.12/src/db/mysql/MysqlConnection.o",
    require => [Exec['configure_libzdb_src']],
    path    => ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"]
  }
  
  exec {'install_libzdb_src':
    cwd     => "/usr/src/packages/libzdb-2.12",
    command => "/usr/bin/make install",
    creates => "/usr/local/lib/libzdb.so.10.0.0",
    require => [Exec['make_libzdb_src']],
    path    => ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"]
  }  
  
}