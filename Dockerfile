FROM ubuntu:14.04

RUN mkdir -p /var/forge/modules

VOLUME /var/forge/modules

CMD ["true"]
