/**
 * compile and install dbmail2.2.18 on ubuntu 12.04.5
 * 
 * author Peter Krebs<pitlinz@sourceforge.net>
 */
class dbmail::dbmail2 (
  $dbdriver   = 'mysql', # Supported drivers are mysql,(pgsql, sqlite not currently compiled).
  $sqlport    = '3306',
  $sqlsocket  = '',

  $dbname     = undef,
  $dbuser     = undef,
  $dbpassword = undef,
  $dbhost     = undef,
  $tblprefix  = "dbmail_",
  $encoding   = "utf8", # encoding must match the database/table encoding i.e. latin1, utf8

  $authdriver = 'sql',  # Supported drivers are sql, ldap.
  
  $bindip     = '*',
  
  $popbeforesmtp  = 'yes',
  $imapbeforesmtp = 'yes',
  
  $sbinpath     = "/usr/local/sbin"  
) {
  class {"dbmail::dbmail2::requirements":
  }
  
  class {"dbmail::dbmail2::compiledbmail":
    require => Class["dbmail::dbmail2::requirements"]
  }
  
  file {"/etc/dbmail.conf":
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0440',
    content => template('dbmail/dbmail2/dbmail.conf.erb'),
    require => Class["dbmail::dbmail2::compiledbmail"]
  }
  
  file {"/etc/init.d/dbmail":
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0550',
    content => template('dbmail/dbmail2/dbmail.init.erb'),
    require => [Class["dbmail::dbmail2::compiledbmail"],File["/etc/dbmail.conf"]]
  }  
  
  file {[
      "/etc/rc2.d/S21dbmail",
      "/etc/rc3.d/S21dbmail",
      "/etc/rc4.d/S21dbmail",
      "/etc/rc5.d/S21dbmail",
      "/etc/rc0.d/K19dbmail",
      "/etc/rc6.d/K19dbmail",
      ]:
    ensure => link,
    require => File["/etc/init.d/dbmail"],
    target => "/etc/init.d/dbmail"
  }
        
}