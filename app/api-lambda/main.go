package main

import (
	"context"
	"encoding/json"
	"fmt"

	"learn-go-lambda-terraform/app/hey"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func HandleRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	fmt.Printf("Processing request body: %s\n", request.Body)
	fmt.Println(request.PathParameters["proxy"])

	var hey hey.Message
	err := json.Unmarshal([]byte(request.Body), &hey)
	if err != nil {
		fmt.Println("Error:", err)
		return events.APIGatewayProxyResponse{Body: "Bad Request", StatusCode: 400}, nil
	}

	msg := fmt.Sprintf("hey, %s. where you goin", hey.Name)
	return events.APIGatewayProxyResponse{Body: msg, StatusCode: 200}, nil
}

func main() {
	lambda.Start(HandleRequest)
}
