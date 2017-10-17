# version: 0.0.1
FROM alpine
MAINTAINER SinceJune "oleooo@126.com"
ENV REFRESHED_AT 2016-07-03

RUN apk add --no-cache nodejs nodejs-npm && \
    npm install -g docsify-cli
ADD . /root
WORKDIR /root
EXPOSE 3000

ENTRYPOINT ["docsify", "serve"]
