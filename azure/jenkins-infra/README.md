# Jenkins Infrastructure (Azure)

This stack provisions the Jenkins platform separately from the application stack.

## Scope

- Resource group
- Virtual network and subnets
- Network security group
- Public IP and Linux VM for Jenkins
- System-assigned managed identity

This is the starting point for the Azure platform implementation. It gives us the Terraform shape needed to continue with Jenkins bootstrap, agent configuration, and tighter access controls.
