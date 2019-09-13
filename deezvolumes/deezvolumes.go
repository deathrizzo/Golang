package main

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/fatih/color"
)

type allVolumes struct {
	VolumeId []string
	State string
	Total int
	Available int
	Used int
	Size int64
}

func main () {
	av := allVolumes{
		VolumeId:  nil,
		State:     "",
		Total:     0,
		Available: 0,
		Used:      0,
		Size:      0,
	}
	results := getVols()
	fmt.Println(results) //here to get json structure if needed.
	av.Total = totalVols(results)
	av.Available, av.Used = volState(results)
	av.Size = totalgp2Size(results)
	//	av.VolumeId = availableVolumeids(results)
	color.Green("Total Volumes: %d", av.Total)
	color.Yellow("Volumes Used: %d", av.Used)
	color.Red("Volumes Available: %d",av.Available)
	fmt.Println("Total GP2 Size: ", av.Size)
	//	fmt.Println(av.VolumeId)
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

func volState(results []*ec2.Volume) (int, int) {
	available := 0
	used := 0
	for _, i := range results {
		st := *i.State
		if st == "available" {
			available++
		} else {
				used++
		}
	}
	return available, used
}

func availableVolumeids(results []*ec2.Volume) []string {
	var ids []string
	for _, i := range results {
		st := *i.State
		if st == "available" {
			ids = append(ids, *i.VolumeId)
		}
	}
	return ids
}

// func give me total of gp2 type size but dont think its needed.
func totalgp2Size(results []*ec2.Volume) int64 {
	var sz int64
	for _, i := range results {
		vtype := *i.VolumeType
		if vtype == "gp2" {
			sz = sz + *i.Size
		}
	}
	return sz
}



/*
func getTime(results []*ec2.Volume) string {

	for _, i := range results {
		ct = i.CreateTime
	}
	return ct
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
		totalVolumes++/
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

*/


/* need a couple of functions here
1. get the count of all volumes DONE!
2. get the count of all available volumes DONE!
	all unused volumes must provide a volumeID Creation time & size
3. get the count of all attached volumes same as In use
4. Maybe get cost for volume type and IOPS from creation time

 */