#!/bin/bash
set -e

# Backup the current leveldb directory
echo "Backing up old leveldb directory..."
if [ -d "leveldb.bak" ]; then
  rm -rf leveldb.bak
fi

if [ -d "leveldb" ]; then
  mv leveldb leveldb.bak
fi

# Update .gitignore to include the XCFramework
echo "Updating .gitignore..."
if ! grep -q "LevelDB.xcframework" .gitignore; then
  echo "LevelDB.xcframework/" >> .gitignore
fi

# Fix the XCFramework headers structure
echo "Fixing XCFramework headers structure..."
chmod +x leveldb_build/fix_xcframework_headers.sh
./leveldb_build/fix_xcframework_headers.sh

# Update the project file to use XCFramework
echo "Opening Xcode project to update LevelDB references..."
open SwiftStore.xcodeproj

echo "Done!"
echo "Please manually update the project to use LevelDB.xcframework instead of the old leveldb directory."
echo "Instructions:"
echo "1. Remove the existing leveldb reference from the project navigator"
echo "2. Drag LevelDB.xcframework into the project navigator (select 'Copy items if needed')"
echo "3. Go to the SwiftStore target > General > Frameworks, Libraries, and Embedded Content"
echo "4. Add LevelDB.xcframework"
echo "5. Go to Build Settings > Search Paths > Header Search Paths"
echo "6. Replace '\$(SRCROOT)/leveldb/include/' with '\$(SRCROOT)/LevelDB.xcframework/Headers'"
echo "7. Go to Other Linker Flags and remove '-lleveldb'"
echo "8. Save and close Xcode"
echo ""
echo "Note: LevelDB headers can now be included using the simplified format:"
echo "  #import <LevelDB/db.h>"
echo "  #import <LevelDB/write_batch.h>"
echo "or the original format:"
echo "  #import <LevelDB/leveldb/db.h>"
echo "  #import <LevelDB/leveldb/write_batch.h>" 