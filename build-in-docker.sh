#!/bin/bash
# Build ml-metadata in Docker and extract the wheel

set -e

# Parse command line arguments
RUN_TESTS=false
while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--test)
      RUN_TESTS=true
      shift
      ;;
    -h|--help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  -t, --test    Run tests after building"
      echo "  -h, --help    Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use -h or --help for usage information"
      exit 1
      ;;
  esac
done

echo "Building ml-metadata Docker image..."
docker build -f Dockerfile.build -t ml-metadata-builder .

echo ""
echo "Running build in container..."
mkdir -p dist-docker
docker run --rm -v "$(pwd)/dist-docker:/output" ml-metadata-builder bash -c "cp /workspace/dist/*.whl /output/"

if [ "$RUN_TESTS" = true ]; then
  echo ""
  echo "Running tests in container..."
  docker run --rm ml-metadata-builder bash -c "cd /workspace && python -m pytest ml_metadata/metadata_store/metadata_store_test.py -v"
fi

echo ""
echo "Build complete! Wheel file is in dist-docker/"
ls -lah dist-docker/

echo ""
echo "To install: pip install dist-docker/*.whl"
