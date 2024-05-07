# Puppet manifest to install and configure nginx web serve and add custom headerr

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
  content => '
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;
	index index.html index.nginx-debian.html;

	server_name _;

	location /redirect_me {
		return 301 https://www.alxafrica.com;
	}

	location / {
		try_files $uri $uri/ =404;
	}
}',
  require => Package['nginx'],
  notify  => Service['nginx'],
}


# get the current hostname of server
$hostname = $::hostname

# Add custom header configuration file
file { '/etc/nginx/nginx.conf':
  ensure  => file,
  owner   => 'www-data',
  group   => 'www-data',
  mode    => '0644',
  content => "
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
        worker_connections 768;
        # multi_accept on;
}

http {

        ##
        # Basic Settings
        ##

        add_header X-Served-By ${hostname};

        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;


        ##
        # SSL Settings
        ##

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
        ssl_prefer_server_ciphers on;

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        ##
        # Gzip Settings
        ##

        gzip on;


        # gzip_vary on;
        # gzip_proxied any;
        # gzip_comp_level 6;
        # gzip_buffers 16 8k;
        # gzip_http_version 1.1;
        # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

        ##
        # Virtual Host Configs
        ##

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
}",
  require => Package['nginx'],
  notify  => Service['nginx'],
}
