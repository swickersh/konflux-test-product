FROM registry.access.redhat.com/ubi9/ubi-minimal

RUN microdnf install -y gzip

RUN mkdir -p /releases && \
    echo 'hello world' | gzip > /releases/linux_test_binary.gz && \
    echo 'hello world' | gzip > /releases/windows_test_binary.gz && \
    echo 'hello world' | gzip > /releases/darwin_test_binary.gz
