#!/bin/bash

# Build clingo-bootstrap
for PYTHON in /opt/python/*/bin/python; do
  # Bootstrap clingo
  ${PYTHON} -m pip install --force-reinstall cmake
  ${PYTHON} spack/bin/spack solve zlib
  ${PYTHON} -m pip uninstall -y cmake
done

