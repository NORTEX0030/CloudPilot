FROM golang:1.20.10-alpine3.18

WORKDIR /app

COPY . .

RUN go build -o app

EXPOSE 8080

CMD ["./app"]
