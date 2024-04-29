# Puppet manifest to kill a process named killmenow

exec { 'kill a process':
  command => '/usr/bin/pkill killmenow'
}
