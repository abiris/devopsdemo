## Defaults

This module is used to set configuration defaults for the AWS infrastructure. It's used only as a helper module for the VPC module configuration.

Usage:
```
module "defaults" {
  source = "bbucket/path"
  region = "us-east-1"
  cidr   = "10.0.0.0/16"
}
```

