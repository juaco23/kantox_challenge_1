# Support for secrets
An easy way to store AWS CMK-encrypted secrets in a Git repository and sync with AWS Secret Manager.
## How does it work?

To simplify the PoC, all the necessary resources were built into Terraform.
You have to configure the AWS credentials or add the profile with your credentials in the provider block and run the Terraform commands: 

* **terraform init**
* **terraform apply -auto-approve**

The following components will be built:
- An AWS CMK to encrypt and decrypt the secret.
- An S3 bucket, in charge of hosting the encrypted secret and firing the lambda
- A lambda with a Python script that will read the bucket secret, decrypt it using the key it was encrypted with, and then set it as a value in SecretManager
- A secret in AWS Secret Manager, which any resource in AWS could use.
- All the necessary permissions for the pipeline to work, and for AWS services to interact with each other

Once all the components are created in the account, the secret must be encrypted in order to start the demo.
**Edit** in the file: **/scripts/encrypt.py** the environment variables:
**SECRET = 'my_db_pass'
KEY_ALIAS = 'alias/my-key'**
If you change the CMK alias in the terraform code, you will also need to change it here as well to match.
Once edited, run the following command in the console.
**python3 /path/to/file/encrypt.py**

When the script finishes, go to the **'/secrets'** folder and you can see that a file called: **mypass.txt** appeared inside, which contains your secret encrypted with the AWS CMK key.
Add the changes to the stage, commit, and push. To trigger the pipeline.
This will run a workflow, which will put this file into AWS S3. 
Once inside the bucket, it will raise an event that will execute the Lambda function.
You could enter the Secret Manager and get the value to verify the operation












<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.15.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.15.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.lambda_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.iam_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_actions_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [tls_certificate.github](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_id_list"></a> [client\_id\_list](#input\_client\_id\_list) | Audience that identifies the application that is registered with an OpenID Connect provider | `list(string)` | <pre>[<br>  "sts.amazonaws.com",<br>  "https://github.com/juaco23"<br>]</pre> | no |
| <a name="input_db_pass_file_name"></a> [db\_pass\_file\_name](#input\_db\_pass\_file\_name) | The name of the file which contains the enrypted password | `string` | `"mypass.txt"` | no |
| <a name="input_function_description"></a> [function\_description](#input\_function\_description) | A simple description for the Lambda Function | `string` | `"Lambda function to decript and update a secret in Secret Manager using KMS key"` | no |
| <a name="input_function_filename"></a> [function\_filename](#input\_function\_filename) | The path to source code | `string` | `"../src/script.zip"` | no |
| <a name="input_function_handler"></a> [function\_handler](#input\_function\_handler) | The Lambda Function Handler | `string` | `"script.lambda_handler"` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | The Lambda Function Name | `string` | `"my_lambda_function"` | no |
| <a name="input_function_runtime"></a> [function\_runtime](#input\_function\_runtime) | The Lambda Function runtime | `string` | `"python3.9"` | no |
| <a name="input_kms_alias"></a> [kms\_alias](#input\_kms\_alias) | The KMS key alias name | `string` | `"alias/my-key"` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The GitHub repository name to connect to AWS | `string` | `"juaco23/kantox_exercise_one"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The bucket Name to store de secret | `string` | `"my-test-bucket-for-this-poc"` | no |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | The Secret Manager name | `string` | `"/db_pass_secret_new"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->