#!/bin/sh

set -e

echo "Creating directories..."
mkdir -p /home/source/TMessagesProj/build/outputs/apk
mkdir -p /home/source/TMessagesProj/build/outputs/bundle
mkdir -p /home/source/TMessagesProj/build/outputs/native-debug-symbols

echo "Copying source files..."
cp -R /home/source/. /home/gradle

cd /home/gradle

echo "Cleaning project..."
gradle clean

echo "Building bundle Afat SDK23..."
gradle :TMessagesProj_App:bundleBundleAfat_SDK23Release \
    --no-daemon \
    --parallel \
    --build-cache \
    -Dorg.gradle.jvmargs="-Xmx2g -XX:MaxMetaspaceSize=512m"

echo "Cleaning intermediate files after first build..."
find /home/gradle -name "*.apk" -not -path "*/outputs/*" -delete
find /home/gradle -name "*.aab" -not -path "*/outputs/*" -delete
rm -rf /home/gradle/.gradle/caches/transforms-*

echo "Building bundle Afat Release..."
gradle :TMessagesProj_App:bundleBundleAfatRelease \
    --no-daemon \
    --parallel \
    --build-cache \
    -Dorg.gradle.jvmargs="-Xmx2g -XX:MaxMetaspaceSize=512m"

echo "Cleaning intermediate files..."
find /home/gradle -name "*.apk" -not -path "*/outputs/*" -delete
find /home/gradle -name "*.aab" -not -path "*/outputs/*" -delete
rm -rf /home/gradle/.gradle/caches/transforms-*

echo "Copying output files..."
cp -R /home/gradle/TMessagesProj_App/build/outputs/apk/. /home/source/TMessagesProj/build/outputs/apk 2>/dev/null || true
cp -R /home/gradle/TMessagesProj_AppHuawei/build/outputs/apk/. /home/source/TMessagesProj/build/outputs/apk 2>/dev/null || true
cp -R /home/gradle/TMessagesProj_AppStandalone/build/outputs/apk/. /home/source/TMessagesProj/build/outputs/apk 2>/dev/null || true
cp -R /home/gradle/TMessagesProj_App/build/outputs/bundle/. /home/source/TMessagesProj/build/outputs/bundle 2>/dev/null || true

echo "Cleaning up..."
rm -rf /home/gradle/.gradle/caches/journal-*

echo "Build completed successfully!"
