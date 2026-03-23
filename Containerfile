FROM registry.access.redhat.com/ubi9/ubi:9.7-1769417801

LABEL \
  name="releng-test-product" \
  com.redhat.component="releng-test-product" \
  description="Test description from containerfile " \
  summary="Test summary" \
  io.k8s.description="Test io.k8s description from containerfile" \
  io.k8s.display-name="releng-test-product" \
  io.openshift.tags="releng-test-product"

RUN mkdir -p /releases && \
    # Download real macOS binaries (unsigned) for testing only
    curl -L https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-macos-amd64 -o /tmp/darwin-amd64 && \
    curl -L https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-macos-arm64 -o /tmp/darwin-arm64 && \
    # Download real Windows binaries (unsigned)
    curl -L https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-windows-amd64.exe -o /tmp/windows-amd64.exe && \
    curl -L https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-windows-i386.exe -o /tmp/windows-i386.exe && \
    chmod +x /tmp/darwin-amd64 /tmp/darwin-arm64 /tmp/windows-amd64.exe /tmp/windows-i386.exe && \
    # Create nested directory structure for darwin and windows (test preservation)
    # Use SAME binary name for different architectures of same OS to test os/arch/ isolation
    mkdir -p /tmp/releng-test-product-binaries-darwin-amd64 && \
    mkdir -p /tmp/releng-test-product-binaries-darwin-arm64 && \
    mkdir -p /tmp/releng-test-product-binaries-windows-amd64 && \
    mkdir -p /tmp/releng-test-product-binaries-windows-i386 && \
    # Copy binaries into nested directories - SAME name for darwin-amd64 and darwin-arm64
    cp /tmp/darwin-amd64 /tmp/releng-test-product-binaries-darwin-amd64/releng-test-product-binaries && \
    echo 'License text for the macOS amd64 binary' > /tmp/releng-test-product-binaries-darwin-amd64/LICENSE && \
    echo 'Changelog for the macOS amd64 binary' > /tmp/releng-test-product-binaries-darwin-amd64/CHANGELOG.md && \
    cp /tmp/darwin-arm64 /tmp/releng-test-product-binaries-darwin-arm64/releng-test-product-binaries && \
    echo 'This is a README for the macOS arm64 binary' > /tmp/releng-test-product-binaries-darwin-arm64/README.md && \
    echo 'License text for the macOS arm64 binary' > /tmp/releng-test-product-binaries-darwin-arm64/LiCeNsE.TxT && \
    cp /tmp/windows-amd64.exe /tmp/releng-test-product-binaries-windows-amd64/releng-test-product-binaries.exe && \
    echo 'This is a README for the Windows amd64 binary' > /tmp/releng-test-product-binaries-windows-amd64/README.MD && \
    echo 'Changelog for the Windows amd64 binary' > /tmp/releng-test-product-binaries-windows-amd64/CHANGELOG && \
    echo 'Installation instructions' > /tmp/releng-test-product-binaries-windows-amd64/INSTALL.txt && \
    cp /tmp/windows-i386.exe /tmp/releng-test-product-binaries-windows-i386/releng-test-product-binaries.exe && \
    echo 'License text for the Windows i386 binary' > /tmp/releng-test-product-binaries-windows-i386/LICENSE.txt && \
    echo 'This is a README for the Windows i386 binary' > /tmp/releng-test-product-binaries-windows-i386/ReadMe && \
    # Compress darwin and windows with nested directory structure preserved
    tar -czf /releases/releng-test-product-binaries-darwin-amd64.tar.gz -C /tmp releng-test-product-binaries-darwin-amd64 && \
    tar -czf /releases/releng-test-product-binaries-darwin-arm64.tar.gz -C /tmp releng-test-product-binaries-darwin-arm64 && \
    tar -czf /releases/releng-test-product-binaries-windows-amd64.tar.gz -C /tmp releng-test-product-binaries-windows-amd64 && \
    # Windows i386: UNCOMPRESSED .tar (testing new feature)
    tar -cf /releases/releng-test-product-binaries-windows-i386.tar -C /tmp releng-test-product-binaries-windows-i386 && \
    # Linux archives: flat structure (no nesting) - same binary name for both architectures
    echo 'hello world amd64' > /tmp/releng-test-product-binaries && \
    echo 'This is a README for the Linux amd64 binary' > /tmp/README.MD && \
    tar -czf /releases/releng-test-product-binaries-linux-amd64.tar.gz -C /tmp releng-test-product-binaries README.MD && \
    echo 'hello world arm64' > /tmp/releng-test-product-binaries && \
    tar -czf /releases/releng-test-product-binaries-linux-arm64.tar.gz -C /tmp releng-test-product-binaries && \
    # Create fake ISO and QCOW files for staged.files[] testing
    echo 'fake ISO content for amd64' > /tmp/install.iso.gz && \
    echo 'fake QCOW content for amd64' > /tmp/disk.qcow2 && \
    echo 'fake ISO content for arm64' > /tmp/install-arm64.iso.gz && \
    echo 'fake QCOW content for arm64' > /tmp/disk-arm64.qcow2 && \
    # Compress ISO and QCOW files
    tar -czf /releases/releng-test-product-iso-amd64.tar.gz -C /tmp install.iso.gz && \
    tar -czf /releases/releng-test-product-qcow2-amd64.tar.gz -C /tmp disk.qcow2 && \
    tar -czf /releases/releng-test-product-iso-arm64.tar.gz -C /tmp install-arm64.iso.gz && \
    tar -czf /releases/releng-test-product-qcow2-arm64.tar.gz -C /tmp disk-arm64.qcow2 && \
    # Clean up
    rm -rf /tmp/darwin-amd64 /tmp/darwin-arm64 /tmp/windows-amd64.exe /tmp/windows-i386.exe /tmp/releng-test-product-binaries /tmp/releng-test-product-binaries-* /tmp/install*.iso.gz /tmp/disk*.qcow2
