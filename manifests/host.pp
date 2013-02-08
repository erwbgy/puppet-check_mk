define check_mk::host (
  $target,
  $host_tags = [],
) {
  $host = $title
  if size($host_tags) > 0
    $_tags = join($host_tags,'|')
    $entry = "${host}|${_tags}"
  }
  else {
    $entry = $host
  }
  concat::fragment { "check_mk-${host}":
    target  => $target,
    content => "  '${entry}',\n",
    order   => 11,
  }
}
