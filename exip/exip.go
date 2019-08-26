package main

import (
	"fmt"
	"github.com/go-external-ip"
	"net"
	"os"
)

func main() {
	// Create the default consensus,
	// using the default configuration and no logger.
	consensus := externalip.DefaultConsensus(nil, nil)
	// Get your IP,
	// which is never <nil> when err is <nil>.
	ip, err := consensus.ExternalIP()
	if err == nil {
		fmt.Println(ip.String()) // print IPv4/IPv6 in string format
	}
	// convert IP to string
	l := ip.String()

	if fileExists("public_ip_collection") {
		fmt.Println("file exists, appending", l)
		n1, err := os.OpenFile("public_ip_collection", os.O_APPEND|os.O_WRONLY, 0644)
		if err != nil {
			fmt.Println(err)
		}
		n1.WriteString("\n")
		n1.WriteString(l)

	} else {
		fmt.Println("creating file")
		f, err := os.Create("public_ip_collection")
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
	fmt.Println("attempting to get information on:", l)
	ipinfo(l)

}
func fileExists(filename string) bool {
	info, err := os.Stat(filename)
	if os.IsNotExist(err) {
		return false
	}
	return !info.IsDir()
	}

func ipinfo(i string) {
	ips, err := net.LookupAddr(i)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Could not get IPs: %v\n", err)
		os.Exit(1)
	}
	fmt.Println(ips)

}
