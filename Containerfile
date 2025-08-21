FROM registry.access.redhat.com/ubi9/ubi:9.6-1755678605

LABEL \
  name="releng-test-product" \
  com.redhat.component="releng-test-product" \
  description="Test description from containerfile " \
  summary="Test summary" \
  io.k8s.description="Test io.k8s description from containerfile" \
  io.k8s.display-name="releng-test-product" \
  io.openshift.tags="releng-test-product"

RUN mkdir -p /releases && \
    echo 'hello world' | gzip > /releases/releng-test-product-binaries-windows-amd64.gz && \
    echo 'hello world' | gzip > /releases/releng-test-product-binaries-linux-amd64.gz && \
    echo 'hello world' | gzip > /releases/releng-test-product-binaries-darwin-amd64.gz && \
    echo 'hello world' | gzip > /releases/releng-test-product-binaries-linux-arm64.gz && \
    echo 'hello world' | gzip > /releases/releng-test-product-binaries-darwin-arm64.gz
