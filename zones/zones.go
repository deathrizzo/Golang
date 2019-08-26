package main

import (
	"fmt"
	"github.com/deathrizzo/golang/zones/pkg/zoneinfo"
	"strings"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/route53"
)

func main() {
	svc := route53.New(session.New())
	input := &route53.ListHostedZonesByNameInput{
	}

	result, err := svc.ListHostedZonesByName(input)
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

	ids := []string {}
//	fmt.Println(len(result.HostedZones))
	for _, i := range result.HostedZones {
		hzid := *i.Id
		//fmt.Println(hzid)
		spid := strings.Split(hzid, "/hostedzone/")
		//fmt.Println(spid[1])
		ids = append(ids, spid[1])
	}
	for _, i := range ids {
	//	fmt.Println(len(ids))
		//fmt.Println(i)
		zoneinfo.ZoneInfo(i)
	}
	//fmt.Println(len(ids))
}
