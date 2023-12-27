locals {
  config = {
    for key, server in azurerm_mysql_flexible_server.flexsqlserver : key => {
      for config_key, config in var.sql_server[key].sql_configurations : config_key => {
        server_name         = server.name
        name                = config.name
        value               = config.value
        resource_group_name = server.resource_group_name
      }
    }
  }

  fw_rules = {
    for key, server in azurerm_mysql_flexible_server.flexsqlserver : key => {
      for rule_key, rule in var.sql_server[key].sql_firewall_rules : rule_key => {
        server_name         = server.name
        name                = rule.name
        start_ip_address    = rule.start_ip_address
        end_ip_address      = rule.end_ip_address
        resource_group_name = server.resource_group_name
      }
    }
  }

}