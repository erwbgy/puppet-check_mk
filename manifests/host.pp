define check_mk::host {
  $host = $title
  concat::fragment { "check_mk-${host}":
    target  => '/etc/check_mk/main.mk',
    content => "  '${host}',\n",
    order   => 02,
  }
}
