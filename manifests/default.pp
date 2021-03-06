## top block to call apt-get update at least once ##
include apt::update
Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
## end top block ##

package { ["python-software-properties","screen","vim","redis-server","zsh","curl","git"]:
   ensure => "installed",
}

include augeas

class {"php": } ->
class {"composer": } ->
class {"pear": } ->

exec {"pear config-set auto_discover 1":
  command => '/usr/bin/pear config-set auto_discover 1'
} ->

pear::package { "phpqatools":
    repository => "pear.phpqatools.org"
} ->
class {"xdebug":} ->

#php5-mysql suggests "apache" and stopping puppet (apt?) installing apache is more hassle than just removing apache.
exec { "apt-get remove apache":
  command => '/usr/bin/apt-get --purge -y remove apache2',
} ->

class {"nginx": }

nginx::resource::vhost { 'packagist.dev.local' :
        ensure => present,
        www_root => '/packagist/web/',
	index_files => ['app_dev.php'],
 	try_files => ['$uri', '$uri/', '@rewriteapp']
}->
nginx::resource::location { 'rewriteapp' :
        ensure => present,
	location => '@rewriteapp',
	www_root => '/packagist/web/',
        location_cfg_append => { 'rewrite' => '^(.*)$ /app_dev.php/$1 last' },
	vhost => 'packagist.dev.local'
}->
nginx::resource::location { 'php' :
        ensure => present,
	location => '~ ^/(app|app_dev|config)\.php(/|$)',
        www_root => '/packagist/web/',
        fastcgi => '127.0.0.1:9000',
        fastcgi_script => '$document_root$fastcgi_script_name',
        vhost => 'packagist.dev.local'
}

class { 'mysql': }
class { 'mysql::server':
  config_hash => { 'root_password' => 'packagist' }
}
mysql::db { 'packagist':
  user     => 'packagist',
  password => 'packagist',
  host     => 'localhost',
  grant    => ['all'],
}

class { "solr": }

vcsrepo { "/packagist/":
    ensure => present,
    provider => git,
    source => "https://github.com/composer/packagist.git"
} ->
file {
    '/packagist/':
    ensure   => 'present',
    mode     => '0775',
    recurse  => 'true',
    owner    => 'vagrant',
    group    => 'vagrant'
}

user { 'www-data':
  groups => ['vagrant']
}

user { 'vagrant':
  groups => ['www-data']
}
