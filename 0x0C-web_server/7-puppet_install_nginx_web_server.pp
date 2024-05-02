# Puppet manifest to install and configure nginx web server

exec { 'install':
  provider => shell,
  command  => 'sudo apt-get -y update ; sudo apt-get -y install nginx ; echo "Hello World!" | sudo tee /var/www/html/index.nginx-debian.html ; sudo sed -i "/server_name _/ r /dev/stdin" /etc/nginx/sites-available/default <<EOF

        location /redirect_me {
                return 301 https://www.alxafrica.com/;
        }
EOF ; sudo service nginx start'
}
