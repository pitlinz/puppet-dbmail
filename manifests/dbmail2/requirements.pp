/**
 * compile all required tools needed by dbmail
 * 
 */
class dbmail::dbmail2::requirements(
) {
  if !defined(File['/usr/src/packages']) {
    file {'/usr/src/packages':
      ensure => directory
    }
  }
  
  package{[
    "libevent-pthreads-2.0-5",
    "libmhash2",
    "libsieve2-1"
  ]:
    ensure => installed
  }
  
  package {[
      'build-essential','flex','pkg-config','libglib2.0-dev',
      'libsieve2-dev',
      'libevent-dev',
      'libmhash-dev',
      'libssl-dev',
      'libmysqlclient-dev',
    ]:
    ensure => installed
  }
  
  class {"dbmail::dbmail2::compilelibzdb":
    require => Package["build-essential","libmysqlclient-dev"]
  }
      
  class {"dbmail::dbmail2::compilegmime":
    require => Package["build-essential","flex","libglib2.0-dev","pkg-config"]
  }  

}