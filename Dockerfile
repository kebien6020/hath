FROM alpine:latest AS build
RUN apk add --no-cache curl unzip
ARG VERSION=1.6.4
RUN curl -L "https://repo.e-hentai.org/hath/HentaiAtHome_${VERSION}.zip" -o /tmp/hath.zip && \
    mkdir /tmp/hath/ && \
    unzip /tmp/hath.zip -d /tmp/hath/

FROM eclipse-temurin:23-jre-alpine

WORKDIR /app
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY --from=build /tmp/hath/HentaiAtHome.jar /app/HentaiAtHome.jar

VOLUME /app/cache
VOLUME /app/download

ENTRYPOINT ["/docker-entrypoint.sh"]
