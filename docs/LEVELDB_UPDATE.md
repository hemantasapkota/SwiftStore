# LevelDB Update

This repository previously used an older version of LevelDB. The code has been updated to use the latest version of LevelDB from the official Google repository.

## Changes Made

1. The latest LevelDB source code was obtained from [Google's LevelDB repository](https://github.com/google/leveldb)
2. A custom build script was created to compile LevelDB for multiple platforms and architectures:
   - iOS (arm64)
   - iOS Simulator (arm64, x86_64)
   - macOS (arm64, x86_64)
3. An XCFramework was created that packages all these binaries together for seamless integration with Xcode

## Benefits of the Update

- Latest LevelDB features and bug fixes
- Improved performance
- Proper multi-architecture support
- Better Xcode integration using XCFramework
- Makes it easier to update LevelDB in the future

## How to Build the LevelDB XCFramework

If you need to rebuild the LevelDB XCFramework, follow these steps:

1. Clone the LevelDB repository:
   ```bash
   git clone --recurse-submodules https://github.com/google/leveldb.git
   ```

2. Use the provided build script from the `leveldb_build` directory:
   ```bash
   cd leveldb_build
   ./build_xcframework.sh
   ```

3. The script will:
   - Build LevelDB for each platform and architecture
   - Create universal binaries for the simulator and macOS
   - Generate an XCFramework in the `output` directory

4. Copy the XCFramework to your project and update the Xcode project settings

5. Run the header fix script to make including headers easier:
   ```bash
   ./leveldb_build/fix_xcframework_headers.sh
   ```

## Updating Xcode Project Settings

1. Remove the existing leveldb references from the project navigator
2. Drag `LevelDB.xcframework` into the project navigator (select "Copy items if needed")
3. Add `LevelDB.xcframework` to the target's "Frameworks, Libraries, and Embedded Content" section
4. Update the header search paths in Build Settings:
   - Replace `$(SRCROOT)/leveldb/include/` with `$(SRCROOT)/LevelDB.xcframework/Headers`
5. Remove the `-lleveldb` flag from "Other Linker Flags"

## Header Inclusion in Code

After running the `fix_xcframework_headers.sh` script, LevelDB headers can be included in two ways:

1. Simple include (recommended):
   ```objc
   #import <LevelDB/db.h>
   #import <LevelDB/write_batch.h>
   // etc.
   ```

2. Original include structure:
   ```objc
   #import <LevelDB/leveldb/db.h>
   #import <LevelDB/leveldb/write_batch.h>
   // etc.
   ```

The fix script:
- Copies all headers from the leveldb/ subdirectory to the Headers root
- Creates symbolic links to handle internal includes between header files
- Maintains compatibility with both import styles

## Troubleshooting

If you encounter include path issues where LevelDB headers can't find each other (e.g., a header tries to include "leveldb/export.h" but can't find it), try one of these solutions:

1. Make sure the XCFramework is properly linked in the "Frameworks, Libraries, and Embedded Content" section
2. Verify that your header search paths are correctly set to `$(SRCROOT)/LevelDB.xcframework/Headers`
3. Run the `./leveldb_build/fix_xcframework_headers.sh` script to fix the header structure 