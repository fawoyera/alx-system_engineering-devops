# Puppet manifest to install and configure nginx web server

# update the apt
exec { 'apt update':
  command => '/usr/bin/apt update',
  before  => Package['nginx']
}

# install nginx
package { 'nginx':
  ensure   => 'installed',
  provider => 'apt',
  before   => Service['nginx']
}

# start nginx
service { 'nginx':
  ensure => 'running',
  before => File['/var/www/html/index.nginx-debian.html']
}

# delete the default index page served by nginx
file { '/var/www/html/index.nginx-debian.html':
  ensure => absent,
  before => File['/var/www/html/some_page.html']
}

# create and add content to new page to be served by nginx
file { '/var/www/html/some_page.html':
  ensure  => present,
  content => 'Hello World!',
  before  => Exec['add new page']'
}

# edit the configuration file and add the new page to it
exec { 'add new page':
  command => '/usr/bin/sed -i \'/index index.html index.htm/s/;$/ some_page.html;/\' /etc/nginx/sites-available/default',
  before  => Exec['add redirect']
}

# add a redirection to the configuration file
exec { 'add redirect':
  command => '/usr/bin/sed -i \'/server_name _/ r /dev/stdin\' /etc/nginx/sites-available/default <<EOF

        location /redirect_me {
                return 301 https://www.alxafrica.com/;
        }
EOF',
  before  => File['/var/www/html/customized_404.html']
}

# create and add content to  custom 404 pag
file { '/var/www/html/customized_404.html':
  ensure  => present,
  content => 'Ceci n\'est pas\' une page',
  before  => Exec['add custom 404 page']
}

# add custom 404 page to configuration file
exec { 'add custom 404 page':
  command => '/usr/bin/sed -i \'/server_name _/ r /dev/stdin\' /etc/nginx/sites-available/default <<EOF

        error_page 404 /customized_404.html;
EOF',
  before  => File['/etc/nginx/sites-enabled/default']
}

# delete the default simlink to configuration file
file { '/etc/nginx/sites-enabled/default':
  ensure => absent,
  before => File['/etc/nginx/sites-enabled/']
}

# create new simlink to configuration file
file { '/etc/nginx/sites-enabled/':
  ensure => link,
  target => '/etc/nginx/sites-available/default',
  before => Service['restart nginx']
}

# restart nginx if configuration file has changed
service { 'restart nginx':
  ensure    => 'running',
  name      => 'nginx',
  enable    => true,
  subscribe => File['/etc/nginx/sites-enabled/']
}
