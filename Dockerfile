FROM alpine:latest AS dl
RUN apk add --no-cache curl unzip
ARG VERSION
RUN curl -L "https://repo.e-hentai.org/hath/HentaiAtHome_${VERSION}_src.zip" -o /tmp/hath.zip && \
    mkdir /tmp/hath/ && \
    unzip /tmp/hath.zip -d /tmp/hath/

FROM eclipse-temurin:11 AS build

RUN apt update && \
    apt install -y git make && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build/
COPY --from=dl /tmp/hath/ ./
COPY *.patch ./

RUN git apply *.patch && \
    make all

FROM eclipse-temurin:11

RUN apt update && apt install -y sqlite3 && apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN mkdir /app/cache /app/download /app/data /app/log /app/tmp
COPY --from=build /build/build/HentaiAtHome.jar /app/HentaiAtHome.jar

VOLUME /app/cache
VOLUME /app/download

ENTRYPOINT ["/docker-entrypoint.sh"]
