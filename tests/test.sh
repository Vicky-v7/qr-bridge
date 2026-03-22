#!/usr/bin/env bash
# Test script for qr-decode.swift
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SWIFT_SRC="$REPO_DIR/scripts/qr-decode.swift"
BINARY="$REPO_DIR/scripts/qr-decode"
TEST_QR="$SCRIPT_DIR/test-qr.png"
EXPECTED_URL="https://example.com/hello"

# Compile if binary doesn't exist
if [ ! -f "$BINARY" ]; then
  echo "Compiling qr-decode.swift..."
  swiftc "$SWIFT_SRC" -o "$BINARY"
  echo "Compiled successfully."
fi

# Run decoder on test QR image
echo "Running decoder on test-qr.png..."
OUTPUT=$("$BINARY" "$TEST_QR" 2>&1) || true

echo "Output: $OUTPUT"

# Check JSON output contains the expected URL (handle escaped slashes in JSON)
DECODED_OUTPUT=$(echo "$OUTPUT" | sed 's|\\\/|/|g')
if echo "$DECODED_OUTPUT" | grep -q "$EXPECTED_URL"; then
  echo "PASS"
  exit 0
else
  echo "FAIL - expected output to contain: $EXPECTED_URL"
  exit 1
fi
