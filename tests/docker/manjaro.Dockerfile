FROM manjarolinux/base:latest

WORKDIR /workspace

CMD ["/workspace/tests/docker/smoke.sh"]
