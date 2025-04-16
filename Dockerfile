# Etapa de descarga
FROM alpine:latest AS downloader

ARG PB_VERSION=0.26.6
ARG TARGETARCH=amd64

RUN apk add --no-cache unzip ca-certificates wget \
  && wget https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_${TARGETARCH}.zip -O /tmp/pb.zip \
  && unzip /tmp/pb.zip -d /pb/ \
  && chmod +x /pb/pocketbase

# Imagen final
FROM alpine:latest

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /pb

COPY --from=downloader /pb/pocketbase /pb/pocketbase
COPY pb_data /pb/pb_data
COPY pb_public /pb/pb_public

EXPOSE 8090

CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8090"]

