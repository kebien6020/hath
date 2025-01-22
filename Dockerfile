FROM alpine:latest AS build
RUN apk add --no-cache curl unzip
ARG VERSION
RUN curl -L "https://repo.e-hentai.org/hath/HentaiAtHome_${VERSION}.zip" -o /tmp/hath.zip && \
    mkdir /tmp/hath/ && \
    unzip /tmp/hath.zip -d /tmp/hath/

FROM eclipse-temurin:11

RUN apt update && apt install -y sqlite3 && apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY --from=build /tmp/hath/HentaiAtHome.jar /app/HentaiAtHome.jar

VOLUME /app/cache
VOLUME /app/download

ENTRYPOINT ["/docker-entrypoint.sh"]
