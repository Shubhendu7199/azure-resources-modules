module "network" {
  source                                   = "./modules/network"
  for_each                                 = var.networks
  opgroup                                  = var.opgroup
  opco                                     = var.opco
  location                                 = each.key
  environment                              = var.environment
  environment_short                        = local.environment_short
  tags                                     = local.tags
  log_analytics_workspace                  = data.azurerm_log_analytics_workspace.management
  nsg_flow_logs_retention_period           = var.nsg_flow_logs_retention_period
  nsg_flow_logs_traffic_analytics_interval = var.nsg_flow_logs_traffic_analytics_interval
  networks                                 = each.value
  subscription_id                          = var.subscription_id
  providers = {
    azurerm = azurerm
  }
}