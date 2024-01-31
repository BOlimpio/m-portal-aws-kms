# m-portal-aws-kms-key
This Terraform module facilitates the creation and management of keys in the AWS Key Management Service (KMS), including the option to create keys replicated across multiple regions. The module provides flexibility by allowing users to define custom IAM policy statements and offers predefined policies for common scenarios. **For additional resources, examples, and community engagement**, check out the portal [Cloudymos](https://cloudymos.com) :cloud:.

## Usage

```
module "kms_primary_key" {
  source = "github.com/BOlimpio/m-portal-aws-kms?ref=v1.0.0"

  key_name              = "cloudymos_primary_key"
  key_description       = "Example KMS Key"
  key_usage             = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  is_enabled            = true
  enable_key_rotation   = true
  multi_region          = true
  deletion_window_in_days = 7
  custom_iam_policy_statement = data.aws_iam_policy_document.custom_primary_key_policy.json
  
  # Default policy to grant admin access too root account
  enable_default_policy = true

  key_administrators    = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/bruno-olimpio"
    ]
  key_users             = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/bruno-olimpio"
    ]

  additional_tags       = {
    Environment = "Production"
  }
}

# # Data source for key policy
data "aws_iam_policy_document" "custom_primary_key_policy" {
  statement {
    sid       = "AllowCloudymosUserKeyRotation"
    effect    = "Allow"
    actions   = [
      "kms:EnableKeyRotation", 
      "kms:DisableKeyRotation"
      ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/cloudymos"]
    }
  }
} 
```

For more detailed examples and use cases, check out the files in the how-to-usage directory. They provide additional scenarios and explanations for leveraging the features of the aws_kms_key module.
## Features

Below features are supported:

  * Pre-configured Key policy for Admin and Common users.  
  * Key rotation support
  * Multi region replica and policy

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| aws | ~> 4.0 |

## Module Inputs
Certainly! Here's the updated table with an additional column indicating whether the variable is required:

| Variable                   | Type             | Description                                                                                                      | Default Value                        | Required                            |
|-----------------------------|------------------|------------------------------------------------------------------------------------------------------------------|--------------------------------------|-------------------------------------|
| key_name                    | string           | The name of the KMS key.                                                                                         |                                      | Yes                                 |
| key_description             | string           | The description of the KMS key.                                                                                  |                                      | No                                  |
| key_usage                   | string           | Specifies the intended use of the KMS key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY.                          | ENCRYPT_DECRYPT                      | No                                  |
| customer_master_key_spec    | string           | Specifies whether the KMS key is a standard key or a FIPS-compliant key. Valid values: SYMMETRIC_DEFAULT or RSA_3072. | SYMMETRIC_DEFAULT                    | No                                  |
| is_enabled                  | bool             | Specifies whether the KMS key is enabled.                                                                       | true                                 | No                                  |
| enable_key_rotation         | bool             | Specifies whether key rotation is enabled.                                                                      | false                                | No                                  |
| multi_region                | bool             | Specifies whether the KMS key can be replicated into different regions.                                          | false                                | No                                  |
| additional_tags             | map(string)      | A map of default tags to apply to the KMS key.                                                                  | {}                                   | No                                  |
| deletion_window_in_days     | number           | The number of days in the key deletion period. Must be between 7 and 30 days.                                     | 30                                   | No                                  |

**Replica Variables:**

| Variable                   | Type             | Description                                                                                                      | Default Value                        | Required                            |
|-----------------------------|------------------|------------------------------------------------------------------------------------------------------------------|--------------------------------------|-------------------------------------|
| create_replica              | bool             | If true, create a replicated KMS key.                                                                           | false                                | No                                  |
| is_enabled_replica          | bool             | If true, the replicated KMS key will be enabled.                                                                | true                                 | No                                  |
| primary_key_arn             | string           | The ARN of the primary key. Provide this when creating a replica.                                                | null                                 | Yes (if create_replica is true)     |

**Policy Variables:**

| Variable                   | Type             | Description                                                                                                      | Default Value                        | Required                            |
|-----------------------------|------------------|------------------------------------------------------------------------------------------------------------------|--------------------------------------|-------------------------------------|
| enable_default_policy       | bool             | Enable the default policy allowing account-wide access to all key operations.                                    | true                                 | No                                  |
| key_administrators          | list(string)     | List of AWS principals who are key administrators.                                                              | []                                   | No                                  |
| key_users                   | list(string)     | List of AWS principals who are key users.                                                                       | []                                   | No                                  |
| custom_iam_policy_statement | string           | Custom policy statements.                                                                                        | ""                                   | No                                  |


### Module Outputs
| Name             | Description                                   | Exported Attributes                                       |
| ---------------- | --------------------------------------------- | --------------------------------------------------------- |
| kms_key          | A map of all kms key attributes              | aws_kms_key.primary_key                                    |
| key_alias  | A map of alias attributes      | aws_kms_replica_key.replica_key                            |
## How to Use Output Attributes
primary_key_arn = module.example_kms.kms_key.arn
**OR**
replica_key_arn = module.example_kms.kms_replica_key["arn"]
## License
This project is licensed under the MIT License - see the [MIT License](https://opensource.org/licenses/MIT) file for details.
## Contributing
Contributions are welcome! Please follow the guidance below for details on how to contribute to this project:
1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Open a pull request
