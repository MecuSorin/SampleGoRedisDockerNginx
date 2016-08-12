FROM golang
EXPOSE 5000

RUN go get github.com/mediocregopher/radix.v2/redis

ADD . /go/src/github.com/mecusorin/SampleGoRedisDockerNginx/main
RUN go install github.com/mecusorin/SampleGoRedisDockerNginx/main

ENTRYPOINT /go/bin/main