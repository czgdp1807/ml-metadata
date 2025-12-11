#!/bin/bash
# Build ml-metadata in Docker and extract the wheel

set -e

echo "Building ml-metadata Docker image..."
docker build -f Dockerfile.build -t ml-metadata-builder .

echo ""
echo "Running build in container..."
mkdir -p dist-docker
docker run --rm -v "$(pwd)/dist-docker:/output" ml-metadata-builder bash -c "cp /workspace/dist/*.whl /output/"

echo ""
echo "Build complete! Wheel file is in dist-docker/"
ls -lah dist-docker/

echo ""
echo "To install: pip install dist-docker/*.whl"
