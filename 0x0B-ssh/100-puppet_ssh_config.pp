# Puppet manifest to configure configuration file of SSH client

file { '/root/.ssh/config':
  ensure  => file,
  path    => '/root/.ssh/config',
  content => "Host 100.26.173.61\n\tHostname 100.26.173.61\n\tIdentityFile ~/.ssh/school\n\tPasswordAuthentication no",
  mode    => '0600'
}
