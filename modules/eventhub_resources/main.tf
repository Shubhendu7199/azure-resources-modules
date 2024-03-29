module "location-lookup" {
  source   = "../location-lookup"
  location = var.region
}

resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  for_each = var.eventhub_resources

  name                = "evhns-wpp-wt-ampm-${var.client_name}-${var.environment}-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.rg_location
  sku                 = each.value.sku

  dynamic "network_rulesets" {
    for_each = each.value.network_rulesets != null ? [each.value.network_rulesets] : []

    content {
      default_action = network_rulesets.value.default_action

      dynamic "virtual_network_rule" {
        for_each = lookup(network_rulesets.value, "vnets", {})

        content {
          ignore_missing_virtual_network_service_endpoint = false
          subnet_id                                       = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${virtual_network_rule.value.vnet_name}/subnets/${virtual_network_rule.value.subnet_name}"
        }
      }
    }
  }
}

resource "azurerm_eventhub_namespace_authorization_rule" "eventhub_namespace_authorization_rule" {
  for_each = var.eventhub_resources

  name                = "evhns-authrule-wt-ampm-${var.client_name}-${var.environment}-${each.value.authorization_rule.name}"
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace[each.key].name
  resource_group_name = var.resource_group_name

  listen = true
  send   = true
  manage = true

  depends_on = [azurerm_eventhub_namespace.eventhub_namespace]
}

resource "azurerm_eventhub" "eventhubs" {
  for_each            = { for k, v in local.eventhub : k => v }
  name                = "evh-wpp-wt-ampm-${var.client_name}-${module.location-lookup.location-lookup["location_short"]}-${var.environment}-${each.value.name}"
  namespace_name      = "evhns-wpp-wt-ampm-${var.client_name}-${var.environment}-${each.value.namespace_name}"
  resource_group_name = var.resource_group_name
  partition_count     = each.value.partition_count
  message_retention   = each.value.message_retention

  depends_on = [azurerm_eventhub_namespace.eventhub_namespace,
  azurerm_eventhub_namespace_authorization_rule.eventhub_namespace_authorization_rule]
}

resource "azurerm_eventhub_authorization_rule" "eventhub_authorization_rules" {
  for_each            = { for k, v in local.authorization_rule : k => v }
  name                = "evh-authrule-ampm-${var.client_name}-${var.environment}-${each.value.config.authorization_rule.name}"
  namespace_name      = "evhns-wpp-wt-ampm-${var.client_name}-${var.environment}-${each.value.namespace_name}"
  eventhub_name       = "evh-wpp-wt-ampm-${var.client_name}-${module.location-lookup.location-lookup["location_short"]}-${var.environment}-${each.value.eventhub_name}"
  resource_group_name = var.resource_group_name
  listen              = try(each.value.config.authorization_rule.listen, null)
  send                = try(each.value.config.authorization_rule.send, null)

  depends_on = [azurerm_eventhub.eventhubs,
    azurerm_eventhub_namespace.eventhub_namespace,
  azurerm_eventhub_namespace_authorization_rule.eventhub_namespace_authorization_rule]
}

resource "azurerm_eventhub_consumer_group" "eventhub_consumer_groups" {
  for_each            = { for k, v in local.consumer_groups : k => v }
  name                = "evh-consgrp-${var.client_name}-${module.location-lookup.location-lookup["location_short"]}-${var.environment}-${each.value.config.name}"
  namespace_name      = "evhns-wpp-wt-ampm-${var.client_name}-${var.environment}-${each.value.namespace_name}"
  eventhub_name       = "evh-wpp-wt-ampm-${var.client_name}-${module.location-lookup.location-lookup["location_short"]}-${var.environment}-${each.value.eventhub_name}"
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_eventhub.eventhubs,
    azurerm_eventhub_authorization_rule.eventhub_authorization_rules,
    azurerm_eventhub_namespace.eventhub_namespace,
  azurerm_eventhub_namespace_authorization_rule.eventhub_namespace_authorization_rule]
}


resource "azurerm_monitor_diagnostic_setting" "eventhubnamespacelog" {
  for_each                   = var.eventhub_resources
  name                       = "evhns-${var.client_name}-${var.environment}-${each.key}-log"
  target_resource_id         = azurerm_eventhub_namespace.eventhub_namespace[each.key].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ArchiveLogs"
  }
  enabled_log {
    category = "OperationalLogs"
  }
  enabled_log {
    category = "AutoScaleLogs"
  }
  enabled_log {
    category = "KafkaCoordinatorLogs"
  }
  enabled_log {
    category = "KafkaUserErrorLogs"
  }
  enabled_log {
    category = "EventHubVNetConnectionEvent"
  }
  enabled_log {
    category = "CustomerManagedKeyUserLogs"
  }
  metric {
    category = "AllMetrics"
  }
  depends_on = [azurerm_eventhub_namespace.eventhub_namespace]
}