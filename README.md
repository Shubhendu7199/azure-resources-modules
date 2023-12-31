## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.7.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | 0.27.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_service_plan"></a> [app\_service\_plan](#module\_app\_service\_plan) | ./modules/app_service_plans | n/a |
| <a name="module_app_services"></a> [app\_services](#module\_app\_services) | ./modules/app_services | n/a |
| <a name="module_eventhub_resources"></a> [eventhub\_resources](#module\_eventhub\_resources) | ./modules/eventhub_resources | n/a |
| <a name="module_flexible_sql_server"></a> [flexible\_sql\_server](#module\_flexible\_sql\_server) | ./modules/flexible_sql_server | n/a |
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | ./modules/key_vault | n/a |
| <a name="module_location-lookup"></a> [location-lookup](#module\_location-lookup) | ./modules/location-lookup | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |
| <a name="module_private_dns_zones"></a> [private\_dns\_zones](#module\_private\_dns\_zones) | ./modules/private_dns_zones | n/a |
| <a name="module_servicebus_resources"></a> [servicebus\_resources](#module\_servicebus\_resources) | ./modules/service_bus | n/a |
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | ./modules/storage_account | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.webinsight](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_automation_account.automation_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) | resource |
| [azurerm_log_analytics_workspace.law](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_resource_group.ampm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_service_plans"></a> [app\_service\_plans](#input\_app\_service\_plans) | n/a | <pre>map(object({<br>    os_type  = string<br>    sku_name = string<br>  }))</pre> | n/a | yes |
| <a name="input_app_services"></a> [app\_services](#input\_app\_services) | Map of app services configuration. | <pre>map(object({<br>    service_plan_id = string<br>    enabled         = bool<br>    https_only      = bool<br><br>    site_config = object({<br>      always_on          = bool<br>      websockets_enabled = bool<br>      app_command_line   = string<br><br>      ip_restriction = optional(object({<br>        action                    = string<br>        headers                   = map(list(string))<br>        ip_address                = optional(string)<br>        name                      = string<br>        service_tag               = optional(string)<br>        virtual_network_subnet_id = optional(string)<br>      }))<br><br>      application_stack = object({<br>        php_version  = optional(string)<br>        node_version = optional(string)<br>      })<br>    })<br><br>    app_settings = map(string)<br><br>    vnet_connection = object({<br>      subnet_id = string<br>    })<br><br>    tags = map(string)<br>  }))</pre> | n/a | yes |
| <a name="input_client_name"></a> [client\_name](#input\_client\_name) | n/a | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment used for naming purposes and tags | `string` | n/a | yes |
| <a name="input_eventhub_resources"></a> [eventhub\_resources](#input\_eventhub\_resources) | n/a | <pre>map(object({<br>    sku = string<br>    network_rulesets = object({<br>      default_action = string<br>      vnets = map(object({<br>        subnet_id = string<br>      }))<br>    })<br>    authorization_rule = object({<br>      name = string<br>    })<br><br>    eventhubs = map(object({<br>      partition_count   = number<br>      message_retention = number<br>      authorization_rule = object({<br>        name   = string<br>        listen = optional(bool)<br>        send   = optional(bool)<br>      })<br>      consumer_groups = list(object({<br>        name = string<br>      }))<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_key_vaults"></a> [key\_vaults](#input\_key\_vaults) | n/a | <pre>map(object({<br>    sku = string<br>    rbac = list(object({<br>      object_id               = string<br>      key_permissions         = list(string)<br>      secret_permissions      = list(string)<br>      certificate_permissions = list(string)<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_networks"></a> [networks](#input\_networks) | Definition for each virtual network we want to create | <pre>map( # In the outer map we expect the location, for example uksouth)<br>    map(      # In the inner map we expect the network name (i.e, my-application)<br>      object({<br>        address_space = list(string)<br>        dns_servers   = optional(list(string), [])<br>        subnets = map(<br>          object({<br>            address_prefix                    = string<br>            service_endpoints                 = optional(list(string), [])<br>            delegation                        = optional(string)<br>            privateEndpointNetworkPolicies    = optional(string)<br>            privateLinkServiceNetworkPolicies = optional(string)<br>          })<br>        )<br>      })<br>    )<br>  )</pre> | `null` | no |
| <a name="input_nsg_flow_logs_retention_period"></a> [nsg\_flow\_logs\_retention\_period](#input\_nsg\_flow\_logs\_retention\_period) | Number of days to store NSG flow logs | `number` | n/a | yes |
| <a name="input_nsg_flow_logs_traffic_analytics_interval"></a> [nsg\_flow\_logs\_traffic\_analytics\_interval](#input\_nsg\_flow\_logs\_traffic\_analytics\_interval) | Interval in minutes at which to send traffic metrics to the Log Analytics instance | `number` | n/a | yes |
| <a name="input_opgroup"></a> [opgroup](#input\_opgroup) | Name of the Group | `string` | n/a | yes |
| <a name="input_private_dns_zones"></a> [private\_dns\_zones](#input\_private\_dns\_zones) | n/a | <pre>map(object({<br>    name = string<br>    vnet_link = map(object({<br>      vnet_id              = list(string)<br>      vnet_subscription_id = optional(string)<br>      vnet_rg_name         = optional(string)<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_region_shortcut"></a> [region\_shortcut](#input\_region\_shortcut) | Updates region to alias | `map(string)` | <pre>{<br>  "centralindia": "inc",<br>  "eastus": "ue",<br>  "eastus2": "ue2",<br>  "germanywestcentral": "gwc",<br>  "northeurope": "eun",<br>  "southafricanorth": "san",<br>  "southeastasia": "ase",<br>  "uksouth": "uks",<br>  "ukwest": "ukw"<br>}</pre> | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_servicebus_resources"></a> [servicebus\_resources](#input\_servicebus\_resources) | n/a | <pre>map(object({<br>    sku = string<br>    namespace_auth_rules = map(object({<br>      listen = bool<br>      send   = bool<br>      manage = bool<br>    }))<br>    topics = map(object({<br>      topic_auth_rules = map(object({<br>        listen = bool<br>        send   = bool<br>        manage = bool<br>      }))<br>    }))<br>    tags = optional(map(string))<br>  }))</pre> | n/a | yes |
| <a name="input_sql_server"></a> [sql\_server](#input\_sql\_server) | n/a | <pre>map(object({<br>    sku_name = string<br>    version  = string<br>    sql_configurations = map(object({<br>      name  = string<br>      value = string<br>    }))<br>    sql_firewall_rules = map(object({<br>      name             = string<br>      start_ip_address = string<br>      end_ip_address   = string<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_storage_accounts"></a> [storage\_accounts](#input\_storage\_accounts) | n/a | <pre>map(object({<br>    index_number             = number<br>    account_tier             = optional(string)<br>    access_tier              = optional(string)<br>    nfsv3_enabled            = optional(bool)<br>    is_hns_enabled           = optional(bool)<br>    large_file_share_enabled = optional(bool)<br>    account_replication_type = optional(string)<br>    account_kind             = optional(string)<br>    network_rules = optional(object({<br>      default_action               = string<br>      bypass                       = optional(list(string))<br>      ip_rules                     = optional(list(string))<br>      virtual_network_subnet_names = optional(list(string))<br>    }))<br>    file_shares = optional(list(object({<br>      name             = string<br>      quota            = number<br>      access_tier      = optional(string)<br>      enabled_protocol = optional(string)<br>    })))<br>    containers = optional(list(object({<br>      name = string<br>    })))<br>  }))</pre> | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
