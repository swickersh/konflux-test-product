FROM registry.access.redhat.com/ubi9/ubi-minimal

LABEL \
  name="releng-test-product" \
  com.redhat.component="releng-test-product" \
  description="Test description from containerfile " \
  io.k8s.description="Test io.k8s description from containerfile" \
  io.k8s.display-name="releng-test-product" \
  io.openshift.tags="releng-test-product"

RUN microdnf install -y gzip

RUN mkdir -p /releases && \
    echo 'hello world' | gzip > /releases/linux_test_binary.gz && \
    echo 'hello world' | gzip > /releases/windows_test_binary.gz && \
    echo 'hello world' | gzip > /releases/darwin_test_binary.gz
