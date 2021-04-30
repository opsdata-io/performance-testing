FROM ubuntu:20.04

MAINTAINER mmattox@support.tools

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    curl \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY run.sh /bin/run.sh
CMD /bin/run.sh
