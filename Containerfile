FROM registry.access.redhat.com/ubi9/ubi:9.7-1764794285

LABEL \
  name="releng-test-product" \
  com.redhat.component="releng-test-product" \
  description="Test description from containerfile " \
  summary="Test summary" \
  io.k8s.description="Test io.k8s description from containerfile" \
  io.k8s.display-name="releng-test-product" \
  io.openshift.tags="releng-test-product"

RUN mkdir -p /releases && \
    # Download real macOS binaries (unsigned)
    curl -L https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-macos-amd64 -o /tmp/darwin-amd64 && \
    curl -L https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-macos-arm64 -o /tmp/darwin-arm64 && \
    # Download real Windows binary (unsigned)
    curl -L https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-windows-amd64.exe -o /tmp/windows-amd64.exe && \
    chmod +x /tmp/darwin-amd64 /tmp/darwin-arm64 /tmp/windows-amd64.exe && \
    # Compress the real binaries as tar.gz
    tar -czf /releases/releng-test-product-binaries-darwin-amd64.tar.gz -C /tmp darwin-amd64 && \
    tar -czf /releases/releng-test-product-binaries-darwin-arm64.tar.gz -C /tmp darwin-arm64 && \
    tar -czf /releases/releng-test-product-binaries-windows-amd64.tar.gz -C /tmp windows-amd64.exe && \
    # Keep simple text for Linux (won't be signed anyway)
    echo 'hello world' > /tmp/linux-amd64 && tar -czf /releases/releng-test-product-binaries-linux-amd64.tar.gz -C /tmp linux-amd64 && \
    echo 'hello world' > /tmp/linux-arm64 && tar -czf /releases/releng-test-product-binaries-linux-arm64.tar.gz -C /tmp linux-arm64 && \
    # Clean up
    rm /tmp/darwin-amd64 /tmp/darwin-arm64 /tmp/windows-amd64.exe /tmp/linux-amd64 /tmp/linux-arm64
