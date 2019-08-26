package zoneinfo
import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/route53"
)

func ZoneInfo(ids string) {
	svc := route53.New(session.New())
	input := &route53.GetHostedZoneInput{
		Id: aws.String(ids),
	}

	result, err := svc.GetHostedZone(input)
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			case route53.ErrCodeNoSuchHostedZone:
				fmt.Println(route53.ErrCodeNoSuchHostedZone, aerr.Error())
			case route53.ErrCodeInvalidInput:
				fmt.Println(route53.ErrCodeInvalidInput, aerr.Error())
			default:
				fmt.Println(aerr.Error())
			}
		} else {
			// Print the error, cast err to awserr.Error to get the Code and
			// Message from an error.
			fmt.Println(err.Error())
		}
		return
	}

	type Zoneinfo struct {
		Id                  string
		Name                string
		ResourceRecordCount int64
		NameServers         []*string
	}
	//bytes := result.HostedZone
	//var res Zoneinfo


	p2 := Zoneinfo{
		Id:                  *result.HostedZone.Id,
		Name:                *result.HostedZone.Name,
		ResourceRecordCount: *result.HostedZone.ResourceRecordSetCount,
		NameServers:         []*string(result.DelegationSet.NameServers),
	}


	fmt.Println("Zone: ", p2.Name)
	fmt.Println("ZoneId: ", p2.Id)
	fmt.Println("Nameservers: ")
	for _, i := range p2.NameServers {
		fmt.Println(*i)

	}
	fmt.Println("RecordCount: ", p2.ResourceRecordCount)
	fmt.Println("\n")

}