# Setup web root and vhost directories
$web_root = [ "/var/www", "/var/www/puppetlabs.dev" ]

file { $web_root:
  ensure => 'directory',
  owner  => 'www-data',
  group  => 'www-data',
  mode   => 775,
}


$example_root = '/var/www/puppetlabs.dev'


# Make sure git is installed for use by vcsrepo
package { git: ensure => installed }


# Pull file from github and place in $example_root directory
vcsrepo { $example_root:
  ensure   => present,
  provider => git,
  source   => 'https://github.com/puppetlabs/exercise-webpage.git',
  revision => master,
  require  => [
        Package[git],
        File[$web_root],
        ]
}


# Ensure resulting file has proper permissions
file { "${example_root}/index.html":
  ensure  => present,
  group   => 'www-data',
  mode    => 0775,
  require => Vcsrepo[$example_root],
}


# Install and bootstrap an nginx instance
class { 'nginx': }


# Setup nginx vhost running on required port and point to file repository
nginx::resource::vhost { 'www.puppetlabs.dev':
  ensure      => present,
  www_root    => $example_root,
  listen_port => 8000,
}


# Setup hosts file to resolve hostname for vhost
$web_host = [ "www.puppetlabs.dev", "puppetlabs.dev" ]

host { $web_host:
  ensure => 'present',
  ip     => '127.0.0.1',
  target => '/etc/hosts',
}
