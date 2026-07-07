FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace

CMD ["/workspace/tests/docker/smoke.sh"]
