


```hcl
locals {
  tags = {
    iac_tool = "terraform"
    environment   = "sratch"
    creation_date = formatdate("YYYY-MM-DD", timestamp())
  }
}
```