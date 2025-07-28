FROM alpine:latest

RUN apk add make gcompat musl-dev gfortran

WORKDIR /app
COPY . .
RUN make compile

ENTRYPOINT ["sh"]
