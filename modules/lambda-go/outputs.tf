output "lambda_function_name" {
  description = "Name of lambda function"
  value       = aws_lambda_function.lambda_function.function_name
}

output "lambda_arn" {
  description = "AWS arn of lambda function"
  value       = aws_lambda_function.lambda_function.arn
}

output "lambda_invoke_arn" {
  description = "AWS arn of lambda function"
  value       = aws_lambda_function.lambda_function.invoke_arn
}