package main

import (
	"context"
	"errors"
	"fmt"
	"os"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cloudfront"
	"github.com/aws/aws-sdk-go-v2/service/cloudfront/types"
	log "github.com/sirupsen/logrus"
)

func handler(ctx context.Context, event events.S3Event) error {
	distributionId := os.Getenv("DISTRIBUTION_ID")
	if distributionId == "" {
		return errors.New("no DISTRIBUTION_ID set")
	}

	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		return errors.New("configuration error, " + err.Error())
	}

	client := cloudfront.NewFromConfig(cfg)
	var items []string
	for _, record := range event.Records {
		if record.S3.Object.Key == "index.html" {
            items = append(items, "/")
        } else {
            items = append(items, fmt.Sprintf("/%s", record.S3.Object.Key))
        }
	}

	timeMillis := time.Now().UnixNano() / (int64(time.Millisecond) / int64(time.Nanosecond))

	_, err = client.CreateInvalidation(ctx, &cloudfront.CreateInvalidationInput{
        DistributionId: aws.String(distributionId),
		InvalidationBatch: &types.InvalidationBatch{
			CallerReference: aws.String(fmt.Sprintf("%d", timeMillis)),
			Paths: &types.Paths{
				Quantity: aws.Int32(1),
				Items: items,
			},
		},
    })

	return err
}

func main() {
	log.SetFormatter(&log.JSONFormatter{})
	lambda.Start(handler)
}