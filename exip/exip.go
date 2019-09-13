package main

import (
	"fmt"
	"github.com/fatih/color"
	"github.com/glendc/go-external-ip"
	"os"
)

var fName string = "public_ip_collection"

func main() {
	// Create the default consensus,
	// using the default configuration and no logger.
	consensus := externalip.DefaultConsensus(nil, nil)
	// Get your IP,
	// which is never <nil> when err is <nil>.
	ip, err := consensus.ExternalIP()
	if err == nil {
		color.Cyan("public ip4: %s", ip.String())

		//fmt.Println(ip.String()) // print IPv4/IPv6 in string format
	}
	// convert IP to string
	l := ip.String()
	//fmt.Println(l)
	if fileExists(fName) {
		color.Cyan("appending to file %s \n", fName)

		n1, err := os.OpenFile(fName, os.O_APPEND|os.O_WRONLY, 0644)
		if err != nil {
			fmt.Println(err)
		}
		n1.WriteString("\n")
		n1.WriteString(l)

	} else {
		fmt.Println("creating file")
		f, err := os.Create(fName)
		if err != nil {
			fmt.Println(err)
			return
		}

		n2, err := f.WriteString(l)
		if err == nil {
			fmt.Printf("wrote %d bytes\n", n2)
		}
		f.Close()
	}
}

func fileExists(filename string) bool {
	info, err := os.Stat(filename)
	if os.IsNotExist(err) {
		return false
	}
	return !info.IsDir()
}
