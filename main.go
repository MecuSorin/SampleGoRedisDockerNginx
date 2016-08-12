/* Author: Mecu Sorin       Phone: 0040747020102 */

package main

import (
	"fmt"
	"html"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/mediocregopher/radix.v2/redis"
)

const redisHits = "hits"

func main() {

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Print(".")

		conn, err := connectToRedis()
		if err != nil {
			fmt.Fprintf(w, "Error connecting Redis: %+v", err)
			return
		}
		defer conn.Close()

		n, err := os.Hostname()
		if nil != err {
			log.Fatal(err)
		}

		fmt.Fprintf(w, "Hello from %q.\nThe requested URL is %q\n", n, html.EscapeString(r.URL.Path))
		hits, err := conn.Cmd("INCR", redisHits).Int()
		if nil != err {
			fmt.Fprintf(w, "Failed to reach the Redis server: %+v\n", err)
		} else {
			fmt.Fprintf(w, "Touched the page %d times\n", hits)
		}
	})
	fmt.Println("Listening on port 5000 ...")
	log.Fatal(http.ListenAndServe(":5000", nil))
}

func connectToRedis() (*redis.Client, error) {
	ticker := time.NewTicker(200 * time.Millisecond)
	timeout := time.NewTimer(5 * time.Second)
	defer func() {
		ticker.Stop()
		timeout.Stop()
	}()
	err := fmt.Errorf("Didn't try to connect Redis")
	for {
		select {
		case <-ticker.C:
			{
				fmt.Println("Dialing Redis")
				redisConn, err := redis.Dial("tcp", "redis:6379")
				if nil == err {
					return redisConn, err
				}
			}
		case <-timeout.C:
			return nil, fmt.Errorf("Timeout in connecting to Redis because (last error: %+v)", err.Error())
		}
	}
}
