# Puppet manifest to install flask from pip3 and upgrade its dependency werkzeug

package { 'flask':
  ensure   => '2.1.0',
  provider => 'pip3',
  before   => Package['werkzeug']
}

package { 'werkzeug':
  ensure   => '2.0.2',
  provider => 'pip3'
}
