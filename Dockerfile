FROM alpine:latest

RUN apk add make gcompat musl-dev gfortran colordiff

WORKDIR /app
COPY . .
RUN make compile

CMD ["sh"]
