$web_root = [ "/var/www", "/var/www/puppetlabs.dev" ]

file { $web_root:
  ensure => 'directory',
  owner  => 'www-data',
  group  => 'www-data',
  mode   => 775,
}

$example_root = '/var/www/puppetlabs.dev'

package { git: ensure => installed }

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

file { "${example_root}/index.html":
  ensure  => present,
  group   => 'www-data',
  mode    => 0775,
  require => Vcsrepo[$example_root],
}

class { 'nginx': }

nginx::resource::vhost { 'www.puppetlabs.dev':
  ensure      => present,
  www_root    => $example_root,
  listen_port => 8000,
}

$web_host = [ "www.puppetlabs.dev", "puppetlabs.dev" ]

host { $web_host:
  ensure => 'present',
  ip     => '127.0.0.1',
  target => '/etc/hosts',
}
