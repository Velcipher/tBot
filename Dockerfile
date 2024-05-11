FROM quay.io/projectquay/golang:1.20 as builder

WORKDIR /go/src/app
COPY . .
RUN make build

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/tbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENV TELE_TOKEN=6629306685:AAENqr8W8cAFDIb5qW9xLjUySrm0URXwIMY
ENTRYPOINT [ "./tbot", "run" ]
