package main

import (
	"context"
	"encoding/json"
	"fmt"

	"learn-go-lambda-terraform/app/hey"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func HandleRequest(ctx context.Context, event events.SQSEvent) (events.SQSBatchItemFailure, error) {
	r := event.Records[0];
	fmt.Printf("Processing request body: %s\n", r.Body)

	var hey hey.Message
	err := json.Unmarshal([]byte(r.Body), &hey)
	if err != nil {
		fmt.Println("Error:", err)
		return events.SQSBatchItemFailure{ItemIdentifier: r.MessageId}, nil
	}

	fmt.Printf("hey, %s. where you goin", hey.Name)
	return events.SQSBatchItemFailure{}, nil
}

func main() {
	lambda.Start(HandleRequest)
}
