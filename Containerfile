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
    # Create nested directory structure for darwin and windows (test preservation)
    # Use SAME binary name for different architectures of same OS to test os/arch/ isolation
    mkdir -p /tmp/releng-test-product-binaries-darwin-amd64 && \
    mkdir -p /tmp/releng-test-product-binaries-darwin-arm64 && \
    mkdir -p /tmp/releng-test-product-binaries-windows-amd64 && \
    # Copy binaries into nested directories - SAME name for darwin-amd64 and darwin-arm64
    cp /tmp/darwin-amd64 /tmp/releng-test-product-binaries-darwin-amd64/releng-test-product-binaries && \
    cp /tmp/darwin-arm64 /tmp/releng-test-product-binaries-darwin-arm64/releng-test-product-binaries && \
    cp /tmp/windows-amd64.exe /tmp/releng-test-product-binaries-windows-amd64/releng-test-product-binaries.exe && \
    # Compress darwin and windows with nested directory structure preserved
    tar -czf /releases/releng-test-product-binaries-darwin-amd64.tar.gz -C /tmp releng-test-product-binaries-darwin-amd64 && \
    tar -czf /releases/releng-test-product-binaries-darwin-arm64.tar.gz -C /tmp releng-test-product-binaries-darwin-arm64 && \
    tar -czf /releases/releng-test-product-binaries-windows-amd64.tar.gz -C /tmp releng-test-product-binaries-windows-amd64 && \
    # Linux archives: flat structure (no nesting) - same binary name for both architectures
    echo 'hello world amd64' > /tmp/releng-test-product-binaries && \
    tar -czf /releases/releng-test-product-binaries-linux-amd64.tar.gz -C /tmp releng-test-product-binaries && \
    echo 'hello world arm64' > /tmp/releng-test-product-binaries && \
    tar -czf /releases/releng-test-product-binaries-linux-arm64.tar.gz -C /tmp releng-test-product-binaries && \
    # Clean up
    rm -rf /tmp/darwin-amd64 /tmp/darwin-arm64 /tmp/windows-amd64.exe /tmp/releng-test-product-binaries /tmp/releng-test-product-binaries-*
