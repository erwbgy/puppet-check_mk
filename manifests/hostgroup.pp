define check_mk::hostgroup (
  $dir,
  $hostgroups,
  $target,
) {
  $group = $title
  $group_tags = join($hostgroups[$group], ',')
  concat::fragment { "check_mk-hostgroup-${host}":
    target  => $target,
    content => "  ( '${group}', [ ${group_tags} ], ALL_HOSTS ),\n",
    order   => 21,
  }
  file { "${dir}/${group}.cfg":
    ensure  => present,
    content => "define hostgroup {\n  hostgroup_name ${group}\n}\n",
    require => File[$dir],
  }
}
