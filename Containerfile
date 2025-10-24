FROM registry.access.redhat.com/ubi9/ubi:9.6-1758184894

LABEL \
  name="releng-test-product" \
  com.redhat.component="releng-test-product" \
  description="Test description from containerfile " \
  summary="Test summary" \
  io.k8s.description="Test io.k8s description from containerfile" \
  io.k8s.display-name="releng-test-product" \
  io.openshift.tags="releng-test-product"

RUN mkdir -p /releases && \
    # Create fake Mach-O binaries with proper magic bytes
    printf '\xcf\xfa\xed\xfe\x07\x00\x00\x01\x03\x00\x00\x80\x02\x00\x00\x00' > /tmp/darwin-amd64 && \
    chmod +x /tmp/darwin-amd64 && \
    gzip -c /tmp/darwin-amd64 > /releases/releng-test-product-binaries-darwin-amd64.gz && \
    printf '\xcf\xfa\xed\xfe\x07\x00\x00\x01\x03\x00\x00\x80\x02\x00\x00\x00' > /tmp/darwin-arm64 && \
    chmod +x /tmp/darwin-arm64 && \
    gzip -c /tmp/darwin-arm64 > /releases/releng-test-product-binaries-darwin-arm64.gz && \
    # Keep text files for non-Mac platforms
    echo 'hello world' | gzip > /releases/releng-test-product-binaries-windows-amd64.gz && \
    echo 'hello world' | gzip > /releases/releng-test-product-binaries-linux-amd64.gz && \
    echo 'hello world' | gzip > /releases/releng-test-product-binaries-linux-arm64.gz && \
    # Clean up
    rm /tmp/darwin-amd64 /tmp/darwin-arm64
