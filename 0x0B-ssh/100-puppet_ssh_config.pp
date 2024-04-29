# Puppet manifest to configure configuration file of SSH client

file { '/etc/ssh/ssh_config':
  ensure  => present,
}
->if 'test `grep -q "
Host 100.26.173.61
	Hostname 100.26.173.61
	IdentityFile ~/.ssh/school
	PasswordAuthentication no" /root/.ssh/config | wc -l` -eq 0' {
  exec { '/usr/bin/echo "
Host 100.26.173.61
	Hostname 100.26.173.61
	IdentityFile ~/.ssh/school
	PasswordAuthentication no" >> /etc/ssh/ssh_config':
  path => '/etc/ssh/ssh_config'
  }
}
