# Contributions

Contributions can be made to this repo by forking and submitting a pull request.

Some conventions used in this repo -

* Support for Terraform 0.11 & 0.12 is managed by branches. Version 0.11 will reside in a branch named 0.11 and version 0.12 code resides in master

* Please run `terraform fmt` to lint the tf files. Formatting changes should be committed with no logic changes - this helps with managing file diffs

* Run `terraform-docs.exe` tool to generate documentation of inputs and outputs, which are added to the README file.

* Use the examples to test - this will require an AWS Account.

* Following the semantics set for versioning/git tags - current tag semantics are `Major.Minor.Build`