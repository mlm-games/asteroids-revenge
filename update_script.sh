#!/bin/bash

# Check if two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <version_name> <version_code>"
    echo "Example: $0 0.10.9 100082"
    
    # Extract the previous version code from export_presets.cfg
    previous_version_code=$(grep 'version/code=' export_presets.cfg | tail -n1 | cut -d'=' -f2)
    echo "Previous version code was: $previous_version_code"
    
    exit 1
fi

version_name=$1
version_code=$2

# Check if a file with the version code exists in the metadata folder
if [ -f "./fastlane/metadata/android/en-US/$version_code" ]; then
    echo "Error: A file with the version code $version_code already exists in the metadata folder."
    echo "Please use a different version code or update the existing file."
    exit 1
fi

# Check if the version name exists in CHANGELOG.md
if ! grep -q "## v$version_name" CHANGELOG.md; then
    echo "Error: Version $version_name not found in CHANGELOG.md"
    exit 1
fi

# Extract the changelog for the given version and save it to a new file
changelog_file="./fastlane/metadata/android/en-US/$version_code.txt"
sed -n "/## v$version_name/,/## v/p" CHANGELOG.md | sed '$d' | sed '1d' > "$changelog_file"

# Check if the changelog was successfully extracted
if [ ! -s "$changelog_file" ]; then
    echo "Error: Failed to extract changelog for version $version_name"
    rm "$changelog_file"
    exit 1
fi

echo "Changelog for version $version_name has been saved to $changelog_file"

# Update version codes and version name in export_presets.cfg
sed -i '' "s/version\/code=[0-9]*/version\/code=$((version_code - 1))/" export_presets.cfg
sed -i '' "s/version\/name=\"[^\"]*\"/version\/name=\"$version_name\"/" export_presets.cfg
sed -i '' "0,/version\/code=[0-9]*/s//version\/code=$version_code/" export_presets.cfg

echo "Updated version codes and version name in export_presets.cfg"

# If we've made it this far, run the butler-upload script
./exports/butler-upload.sh "$version_name"

echo "Upload completed successfully!"