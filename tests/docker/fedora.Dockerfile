FROM fedora:44

WORKDIR /workspace

CMD ["/workspace/tests/docker/smoke.sh"]
