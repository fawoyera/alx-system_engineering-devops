# Puppet manifest to install and configure nginx web server and add custom headerr

# Install Nginx
package { 'nginx':
  ensure => installed,
}

# Start Nginx
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx']
}

# Edit default index page
file { '/var/www/html/index.nginx-debian.html':
  ensure  => file,
  owner   => 'www-data',
  group   => 'www-data',
  mode    => '0755',
  content => 'Hello World!',
}

# Edit configuration file
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  owner   => 'www-data',
  group   => 'www-data',
  mode    => '0755',
  content => "
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;
	index index.html index.nginx-debian.html;

	server_name _;

        add_header X-Served-By ${HOSTNAME};

	location /redirect_me {
		return 301 https://www.alxafrica.com;
	}

	location / {
		try_files $uri $uri/ =404;
	}
}",
  require => Package['nginx'],
  notify  => Service['nginx'],
}
