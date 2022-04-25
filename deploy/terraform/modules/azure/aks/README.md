


```hcl
locals {
  tags = {
    iac_tool = "terraform"
    environment   = "dev"
    creation_date = formatdate("YYYY-MM-DD", timestamp())
  }
}
```