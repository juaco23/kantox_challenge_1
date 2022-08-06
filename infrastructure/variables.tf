# ENCRYPTED DB PASS FILE
variable "db_pass_file_name" {
  default     = "mypass.txt"
  description = "The name of the file which contains the enrypted password"
  type        = string

}
variable "client_id_list" {
  description = "Audience that identifies the application that is registered with an OpenID Connect provider"
  type        = list(string)
  default = [
    "sts.amazonaws.com",
    "https://github.com/juaco23"
  ]
}
#S3 BUCKET VARIABLES
variable "s3_bucket_name" {
  default     = "my-test-bucket-for-this-poc"
  description = "The bucket Name to store de secret"
  type        = string

}

#LAMBDA FUNCTION VARIABLES

variable "function_name" {
  default     = "my_lambda_function"
  description = "The Lambda Function Name"
  type        = string

}
variable "function_handler" {
  default     = "script.lambda_handler"
  description = "The Lambda Function Handler"
  type        = string

}

variable "function_description" {
  description = "A simple description for the Lambda Function"
  default     = "Lambda function to decript and update a secret in Secret Manager using KMS key"
  type        = string
}
variable "function_runtime" {
  description = "The Lambda Function runtime"
  default     = "python3.9"
  type        = string
}
variable "function_filename" {
  default     = "../src/script.zip"
  description = "The path to source code"
  type        = string
}

# SECRET MANAGER VARIABLE
variable "secret_name" {
  default     = "/db_pass_secret_new"
  description = "The Secret Manager name"
  type        = string
}

#KMS VARIABLE
variable "kms_alias" {
  default     = "alias/my-key"
  description = "The KMS key alias name"
  type        = string
}

#GITHUB REPOSITORY

variable "repo_name" {
  default     = "juaco23/kantox_exercise_one"
  description = "The GitHub repository name to connect to AWS"
  type        = string
}