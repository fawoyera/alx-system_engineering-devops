# Puppet manifest to install and configure nginx web server

exec { 'install':
  provider => shell,
  command  => 'sudo apt-get -y update ; sudo apt-get -y install nginx ; echo "Hello World!" | sudo tee /var/www/html/index.nginx-debian.html ; sudo sed -i "/server_name _/s/;$/;\n\tlocation /redirect_me { return 301 https:\/\/www.alxafrica.com\/; }/ /etc/nginx/sites-available/default ; sudo service nginx start'
}
