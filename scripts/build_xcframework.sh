#!/bin/bash
set -e

# Define the current directory and output directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEVELDB_SRC_DIR="${SCRIPT_DIR}/leveldb"
BUILD_DIR="${SCRIPT_DIR}/build"
OUTPUT_DIR="${SCRIPT_DIR}/output"
FRAMEWORK_NAME="LevelDB"

# Make sure the leveldb source exists
if [ ! -d "$LEVELDB_SRC_DIR" ]; then
    echo "LevelDB source not found at $LEVELDB_SRC_DIR"
    exit 1
fi

# Create necessary directories
mkdir -p "${BUILD_DIR}"
mkdir -p "${OUTPUT_DIR}"

# Function to build LevelDB for a specific platform and architecture
build_leveldb() {
    local platform=$1
    local arch=$2
    local deployment_target=$3
    local build_folder="${BUILD_DIR}/${platform}-${arch}"
    
    echo "Building LevelDB for ${platform} ${arch} with deployment target ${deployment_target}..."
    
    mkdir -p "${build_folder}"
    cd "${build_folder}"
    
    # Set up CMake arguments
    CMAKE_ARGS=(
        "-DCMAKE_BUILD_TYPE=Release"
        "-DLEVELDB_BUILD_TESTS=OFF"
        "-DLEVELDB_BUILD_BENCHMARKS=OFF"
        "-DCMAKE_OSX_DEPLOYMENT_TARGET=${deployment_target}"
        "-DCMAKE_OSX_ARCHITECTURES=${arch}"
        "-DCMAKE_CXX_STANDARD=17"
        "-DCMAKE_CXX_STANDARD_REQUIRED=ON"
        "-DCMAKE_CXX_FLAGS=-stdlib=libc++"
    )
    
    # Add platform-specific options
    if [ "$platform" == "iphoneos" ] || [ "$platform" == "iphonesimulator" ]; then
        CMAKE_ARGS+=(
            "-DCMAKE_SYSTEM_NAME=iOS"
        )
        if [ "$platform" == "iphonesimulator" ]; then
            CMAKE_ARGS+=(
                "-DCMAKE_OSX_SYSROOT=iphonesimulator"
            )
        else
            CMAKE_ARGS+=(
                "-DCMAKE_OSX_SYSROOT=iphoneos"
            )
        fi
    fi
    
    # Configure and build
    cmake "${CMAKE_ARGS[@]}" "${LEVELDB_SRC_DIR}"
    cmake --build . --config Release
    
    # Create framework structure
    local framework_dir="${build_folder}/${FRAMEWORK_NAME}.framework"
    mkdir -p "${framework_dir}/Headers"
    
    # Copy the static library
    cp "libleveldb.a" "${framework_dir}/${FRAMEWORK_NAME}"
    
    # Copy header files
    cp -R "${LEVELDB_SRC_DIR}/include/leveldb" "${framework_dir}/Headers/"
    
    # Create Info.plist
    cat > "${framework_dir}/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>${FRAMEWORK_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>com.google.leveldb</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>${FRAMEWORK_NAME}</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>MinimumOSVersion</key>
    <string>${deployment_target}</string>
</dict>
</plist>
EOF

    echo "Built framework at: ${framework_dir}"
}

# Function to create a universal framework
create_universal_framework() {
    local platform=$1
    local archs=("${@:2}")
    local framework_name=$FRAMEWORK_NAME
    local universal_dir="${BUILD_DIR}/universal-${platform}"
    
    mkdir -p "${universal_dir}"
    mkdir -p "${universal_dir}/${framework_name}.framework"
    
    # Create universal binary
    local libs=()
    for arch in "${archs[@]}"; do
        libs+=("${BUILD_DIR}/${platform}-${arch}/${framework_name}.framework/${framework_name}")
    done
    
    # Use lipo to create a universal binary
    lipo -create "${libs[@]}" -output "${universal_dir}/${framework_name}.framework/${framework_name}"
    
    # Copy headers from the first architecture (they're the same for all)
    cp -R "${BUILD_DIR}/${platform}-${archs[0]}/${framework_name}.framework/Headers" "${universal_dir}/${framework_name}.framework/"
    
    # Copy Info.plist
    cp "${BUILD_DIR}/${platform}-${archs[0]}/${framework_name}.framework/Info.plist" "${universal_dir}/${framework_name}.framework/"
    
    echo "Created universal framework at: ${universal_dir}/${framework_name}.framework"
    return 0
}

# Build for different platforms
# iOS
build_leveldb "iphoneos" "arm64" "11.0"

# iOS Simulator
build_leveldb "iphonesimulator" "arm64" "11.0"
build_leveldb "iphonesimulator" "x86_64" "11.0"

# macOS
build_leveldb "macos" "arm64" "10.15"
build_leveldb "macos" "x86_64" "10.15"

# Create universal frameworks
create_universal_framework "iphonesimulator" "arm64" "x86_64"
create_universal_framework "macos" "arm64" "x86_64"

# Create XCFramework
echo "Creating XCFramework..."
xcrun xcodebuild -create-xcframework \
    -framework "${BUILD_DIR}/iphoneos-arm64/${FRAMEWORK_NAME}.framework" \
    -framework "${BUILD_DIR}/universal-iphonesimulator/${FRAMEWORK_NAME}.framework" \
    -framework "${BUILD_DIR}/universal-macos/${FRAMEWORK_NAME}.framework" \
    -output "${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework"

echo "XCFramework created at: ${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework" 