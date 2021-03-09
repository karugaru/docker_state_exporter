FROM golang:alpine as builder
RUN apk update && apk add git && apk add ca-certificates
COPY *.go $GOPATH/src/mypackage/myapp/
WORKDIR $GOPATH/src/mypackage/myapp/
RUN go mod init && go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/docker_state_exporter

FROM alpine:3
COPY --from=builder /go/bin/docker_state_exporter /go/bin/docker_state_exporter
EXPOSE 8080
ENTRYPOINT ["/go/bin/docker_state_exporter"]
CMD ["-listen-address=:8080"]