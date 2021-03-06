FROM alpine:latest

ARG APPLICATION="myapp"
ARG BUILD_RFC3339="1970-01-01T00:00:00Z"
ARG REVISION="local"
ARG DESCRIPTION="no description"
ARG PACKAGE="user/repo"
ARG VERSION="dirty"

STOPSIGNAL SIGKILL

LABEL org.opencontainers.image.ref.name="${PACKAGE}" \
    org.opencontainers.image.created=$BUILD_RFC3339 \
    org.opencontainers.image.authors="Justin J. Novack <jnovack@gmail.com>" \
    org.opencontainers.image.documentation="https://github.com/${PACKAGE}/README.md" \
    org.opencontainers.image.description="${DESCRIPTION}" \
    org.opencontainers.image.licenses="GPLv3" \
    org.opencontainers.image.source="https://github.com/${PACKAGE}" \
    org.opencontainers.image.revision=$REVISION \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.url="https://hub.docker.com/r/${PACKAGE}/"

ENV \
    APPLICATION="${APPLICATION}" \
    BUILD_RFC3339="${BUILD_RFC3339}" \
    REVISION="${REVISION}" \
    DESCRIPTION="${DESCRIPTION}" \
    PACKAGE="${PACKAGE}" \
    VERSION="${VERSION}"

RUN mkdir /opt/flexget && \
    apk add --update --no-cache python3 ca-certificates && \
    pip3 install --no-cache-dir --upgrade pip flexget transmissionrpc

# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

VOLUME /opt/flexget
WORKDIR /opt/flexget

ENTRYPOINT [ "/entrypoint.sh" ]
COPY entrypoint.sh /
