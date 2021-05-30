locals {
  source_path   = "${abspath(var.resource_path)}/${var.lambda_function_name}"
  function_name = "${var.prefix_name}${var.lambda_function_name}"
  source_code   = join("", [for file in fileset(local.source_path, "*") : filesha1("${local.source_path}/${file}")])
  name_snake_case = lower(replace(replace(var.lambda_function_name, "_", "-"), " ", "-"))
}

# -----------------------------------------------------------------------------
# Package the lambda function
# -----------------------------------------------------------------------------

resource "null_resource" "package_lambda" {
  triggers = {
    sha1_hash = sha1(local.source_code)
  }

  provisioner "local-exec" {
    command = "bash .${path.module}/rust-packager.sh"

    environment = {
      SOURCE_PATH  = local.source_path
      PACKAGE_NAME = var.lambda_function_name
      OUTPUT_ZIP   = "${local.source_path}-package.zip"
    }
  }
}

data "local_file" "packaged_zip" {
  depends_on = [null_resource.package_lambda]

  filename = "${local.source_path}-package.zip"
}

# -----------------------------------------------------------------------------
# Upload packaged function to lambda
# -----------------------------------------------------------------------------

resource "aws_s3_bucket" "lambda_bucket" {
  acl    = "private"
  bucket = "satimoto-${var.deployment_stage}-${local.name_snake_case}-lambda-function"
}

resource "aws_s3_bucket_object" "lambda_object" {
  depends_on = [null_resource.package_lambda]

  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "${var.lambda_function_name}-package.zip"
  source = "${local.source_path}-package.zip"
  etag   = md5(local.source_code)
}

# -----------------------------------------------------------------------------
# Create the lambda role
# -----------------------------------------------------------------------------

resource "aws_iam_role" "lambda_role" {
  name = "lambda-${var.lambda_function_name}-role"

  assume_role_policy = file("${path.module}/lambda-role.json")
}

resource "aws_iam_role_policy_attachment" "lambda_role_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# -----------------------------------------------------------------------------
# Create the lambda function
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "lambda_function" {
  depends_on = [aws_s3_bucket_object.lambda_object]

  handler           = var.lambda_handler
  function_name     = local.function_name
  memory_size       = var.lambda_memory_size
  role              = aws_iam_role.lambda_role.arn
  runtime           = var.lambda_runtime
  s3_bucket         = aws_s3_bucket.lambda_bucket.id
  s3_key            = aws_s3_bucket_object.lambda_object.key
  s3_object_version = aws_s3_bucket_object.lambda_object.version_id
  source_code_hash  = sha256(data.local_file.packaged_zip.content_base64)
  timeout           = var.lambda_timeout

  environment {
    variables = var.lambda_environment_variables
  }

  vpc_config {
    subnet_ids         = var.lambda_vpc_subnet_ids
    security_group_ids = var.lambda_vpc_security_group_ids
  }
}
