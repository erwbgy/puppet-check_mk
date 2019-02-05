class check_mk::agent::plugin::logwatch {
	check_mk::agent::plugin{"logwatch":
		config_file => "/etc/check_mk/logwatch.cfg",
		config_file_template => "check_mk/agent/plugin/logwatch.cfg.erb",
	}
}