variable "region" {
  description = "The AWS region"
  default     = "eu-central-1"
}

variable "deployment_stage" {
  description = "The deployment stage"
  default     = "testnet"
}

variable "availability_zones" {
  description = "A list of Availability Zones where subnets and DB instances can be created"
}

# -----------------------------------------------------------------------------
# Module lambda-rust
# -----------------------------------------------------------------------------

variable "resource_path" {
  description = "The path to the resources directory containing the lambda functions"
  default     = "../../resources/lambda"
}

variable "prefix_name" {
  description = "A prefix name to the Lambda Function name"
  default     = ""
}

variable "lambda_handler" {
  description = "The function entrypoint in your code"
  default     = "main"
}

variable "lambda_layers" {
  description = "List of Lambda Layer Version ARNs"
  type        = list
  default     = []
}

variable "lambda_memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  default     = 128
}

variable "lambda_function_name" {
  description = "A unique name for your Lambda Function"
}

variable "lambda_publish" {
  description = "Whether to publish creation/change as new Lambda Function Version"
  default     = false
}

variable "lambda_runtime" {
  description = "The runtime for your Lambda Function"
  default     = "go1.x"
}

variable "lambda_timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
}

variable "lambda_environment_variables" {
  description = "A map that defines environment variables for the Lambda function"
  type        = map
  default     = {}
}

variable "lambda_vpc_subnet_ids" {
  description = "A list of subnet IDs associated with the Lambda function"
  type        = list(string)
  default     = []
}

variable "lambda_vpc_security_group_ids" {
  description = "A list of security group IDs associated with the Lambda function"
  type        = list(string)
  default     = []
}
