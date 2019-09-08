package main

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
)

type allVolumes struct {
	VolumeId []string
	State string
	Total int
	Available int
	Used int
}

func main () {
	av := allVolumes{
		VolumeId:  nil,
		State:     "",
		Total:     0,
		Available: 0,
		Used:      0,
	}

	results := getVols()
	fmt.Println(results)
	av.Total = totalVols(results)
	fmt.Println(av.Total)
	av.VolumeId = getVolumeids(results)
	fmt.Println(av.VolumeId)
	//fmt.Println(av.Count)
	//available := state(results)
	//fmt.Println(available)
}


func getVols() []*ec2.Volume {
	svc := ec2.New(session.New(&aws.Config{
		Region: aws.String("us-west-2"),
	}))

	input := &ec2.DescribeVolumesInput{}

	result, err := svc.DescribeVolumes(input)
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			default:
				fmt.Println(aerr.Error())
			}
		} else {
			// Print the error, cast err to awserr.Error to get the Code and
			// Message from an error.
			fmt.Println(err.Error())
		}
	}
	results := result.Volumes
	return results
}

func totalVols (results []*ec2.Volume) int {
	ct := 0
	for range results {
		ct++
	}
	return ct
}

func availableState(results []*ec2.Volume) int {
	available := 0
	for _, i := range results {
		st := *i.State
		if st == "available" {
			available++
		}
	}
	return available
}

func getVolumeids(results []*ec2.Volume) []string {
	var ids []string
	for _, i := range results {
		ids = append(ids, *i.VolumeId)
	}
	return ids
}




/*
func All(a *[]string) {
	for _, i := range a {
		fmt.Println(i)
	}
}

 */
	/*
	//fmt.Println(result.Volumes)
	//ids := []string {}
	totalVolumes := 0
	availableVolumes := 0
	availableVids := []
	for _, i := range result.Volumes {
		totalVolumes++
		//vids := *i.VolumeId
		st := *i.State/
		ct := *i.CreateTime
		if st == "available" {
			availableVolumes++
			availableVids = *i.VolumeId
			fmt.Println(ct)

		}
		fmt.Println(st)
		/fmt.Println(ct)
	}
	fmt.Println("Total Volumes: ", totalVolumes)
	fmt.Println("Total Available: ", availableVolumes)
	fmt.Println("VolumeIds Available:", availableVids)
	type Volumes struct {
		Total []int
		Id []*string
		State []*string
		Size []*int
	}




}
	/*
	all := result.Volumes
	fmt.Println(all)

	type Volumes struct {
		Id []*string
		State []*string
		Size []*int
	}



	for _, i := range all {
		fmt.Println(i.State)


	}



}


	//fmt.Println(result.Volumes)
	//blah := []int

*/


/* need a couple of functions here
1. get the count of all volumes
2. get the count of all available volumes
	all unused volumes must provide a volumeID Creation time & size
3. get the count of all attached volumes
 */