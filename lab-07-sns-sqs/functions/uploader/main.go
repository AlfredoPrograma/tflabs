package main

import (
	"context"
	"encoding/json"
	"errors"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

// Dependencies holds the external resources required by the application,
// including an S3 client for interacting with AWS S3 and the name of the S3 bucket.
type Dependencies struct {
	S3Client *s3.Client
	Bucket   string
}

// NewDependencies initializes and returns a new Dependencies instance by loading the S3 bucket name
// from the environment variable "S3_BUCKET_NAME" and creating an S3 client using the default AWS configuration.
// It returns an error if the bucket name is unset or if the AWS configuration fails to load.
func NewDependencies(ctx context.Context) (*Dependencies, error) {
	bucket := os.Getenv("S3_BUCKET_NAME")

	if bucket == "" {
		err := errors.New("target bucket name unset")
		return nil, err
	}

	cfg, err := config.LoadDefaultConfig(ctx)

	if err != nil {
		return nil, err
	}

	s3Client := s3.NewFromConfig(cfg)

	return &Dependencies{s3Client, bucket}, nil
}

// Request represents a payload containing a key and its associated content.
// The Key field typically identifies the resource, while Content holds the data to be processed.
type Request struct {
	Key     string `json:"key"`
	Content string `json:"content"` // Expected content to be base64 encoded
}

// handleRequest processes an AWS SQS event containing messages with S3 upload requests.
// For each record in the event, it unmarshals the message, extracts the upload request,
// and uploads the specified content to the configured S3 bucket using the provided key.
// Returns an error if any step fails during processing.
func handleRequest(ctx context.Context, event events.SQSEvent) error {
	deps, err := NewDependencies(ctx)

	if err != nil {
		return err
	}

	for _, record := range event.Records {
		var message map[string]any

		if err = json.Unmarshal([]byte(record.Body), &message); err != nil {
			return err
		}

		var req Request

		if err = json.Unmarshal([]byte(message["Message"].(string)), &req); err != nil {
			return err
		}

		_, err = deps.S3Client.PutObject(ctx, &s3.PutObjectInput{
			Bucket: aws.String(deps.Bucket),
			Key:    aws.String(req.Key),
			Body:   strings.NewReader(req.Content),
		})

		if err != nil {
			return err
		}

	}

	return nil
}

func main() {
	lambda.Start(handleRequest)
}
