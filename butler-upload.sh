#!/bin/bash

cd ./exports

if [ $# -eq 0 ]; then
    echo "Please provide a version number as an argumentz."
    exit 1
fi

# Check if we're in the ./exports directory of a git repo
if [ "$(basename "$(pwd)")" != "exports" ] || [ ! -d ../.git ]; then
    echo "Error: This script must be run from the ./exports directory of a git repository."
    exit 1
fi

version=$1

# Set the path to the folder you want to zip
folder_path="./web"

# Set the Butler targets for each platform
web_target="ragebreaker/asteroids-revenge:web"
windows_target="ragebreaker/asteroids-revenge:windows"
linux_target="ragebreaker/asteroids-revenge:linux"
linux_arm64_target="ragebreaker/asteroids-revenge:linux-arm64"
macos_target="ragebreaker/asteroids-revenge:macos"
android_arm32_target="ragebreaker/asteroids-revenge:android-arm32"
android_arm64_target="ragebreaker/asteroids-revenge:android-arm64"

# Change directory to the specified folder
cd "$folder_path"

# Zip all the contents of the folder without creating a new folder
zip -r web.zip *

mv web.zip ../

cd ..

# Upload the zip files to their respective Butler targets
butler push web.zip "$web_target" --userversion "$version"
butler push asteroids-revenge-windows.exe "$windows_target" --userversion "$version"
butler push asteroids-revenge-linux.x86_64 "$linux_target" --userversion "$version"
butler push asteroids-revenge-linux-aarch64.arm64 "$linux_arm64_target" --userversion "$version"
butler push asteroids-revenge-macOS.zip "$macos_target" --userversion "$version"
butler push asteroids-revenge-android-arm32.apk "$android_arm32_target" --userversion "$version"
butler push asteroids-revenge-android-arm64.apk "$android_arm64_target" --userversion "$version"

# Prompt the user to press any key to exit
echo "Press any key to exit..."
read -n 1 -s
