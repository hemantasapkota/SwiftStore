#!/bin/bash
set -e

# This script fixes the LevelDB.xcframework header structure to make it easier to include headers

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XCFRAMEWORK_PATH="${SCRIPT_DIR}/../LevelDB.xcframework"

if [ ! -d "$XCFRAMEWORK_PATH" ]; then
    echo "LevelDB.xcframework not found at $XCFRAMEWORK_PATH"
    exit 1
fi

echo "Fixing header structure in LevelDB.xcframework..."

# Find all platform directories in the XCFramework
PLATFORM_DIRS=$(find "$XCFRAMEWORK_PATH" -type d -name "LevelDB.framework")

for PLATFORM_DIR in $PLATFORM_DIRS; do
    echo "Processing $PLATFORM_DIR..."
    HEADERS_DIR="${PLATFORM_DIR}/Headers"
    
    # Copy headers to the root for easier include
    if [ -d "${HEADERS_DIR}/leveldb" ]; then
        echo "Copying leveldb headers to root Headers directory..."
        cp -f "${HEADERS_DIR}/leveldb"/*.h "${HEADERS_DIR}/"
        
        # Create a symlink from leveldb/leveldb to leveldb for nested includes
        mkdir -p "${HEADERS_DIR}/leveldb/leveldb"
        for HEADER in "${HEADERS_DIR}/leveldb"/*.h; do
            HEADER_NAME=$(basename "$HEADER")
            ln -sf "../${HEADER_NAME}" "${HEADERS_DIR}/leveldb/leveldb/${HEADER_NAME}"
        done
    fi
done

echo "Header structure fixed successfully!"
echo ""
echo "Now you can include LevelDB headers in your code using:"
echo "  #import <LevelDB/db.h>"
echo "  #import <LevelDB/write_batch.h>"
echo "  // etc."
echo ""
echo "Or if you prefer the existing structure:"
echo "  #import <LevelDB/leveldb/db.h>"
echo "  #import <LevelDB/leveldb/write_batch.h>"
echo "  // etc." 