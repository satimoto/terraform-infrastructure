package main

import "github.com/aws/aws-lambda-go/lambda"

func handle() (string, error) {
	return "Hello World", nil
}

func main () {
	lambda.Start(handle)
}