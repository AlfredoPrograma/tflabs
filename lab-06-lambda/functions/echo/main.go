package main

import (
	"context"
	"encoding/json"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Response struct {
	Message string `json:"message"`
}

func handleRequest(ctx context.Context, event events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	payload := make(map[string]any)
	json.Unmarshal([]byte(event.Body), &payload)

	response, _ := json.Marshal(Response{Message: payload["message"].(string)})

	return events.APIGatewayProxyResponse{
		StatusCode:      200,
		Body:            string(response),
		Headers:         map[string]string{"Content-Type": "application/json"},
		IsBase64Encoded: false,
	}, nil
}

func main() {
	lambda.Start(handleRequest)
}
