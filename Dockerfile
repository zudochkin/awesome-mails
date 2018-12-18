
#build stage
FROM golang:alpine AS builder

WORKDIR /app

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GO111MODULE=on

COPY . .

RUN apk add --no-cache git

RUN go mod download

# Build the binary
RUN go build -ldflags="-w -s" -o /app/main

#final stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates

COPY --from=builder /app/main /app/main

LABEL Name=awesome-mails Version=0.0.1

EXPOSE 3000

ENTRYPOINT ./app/main
