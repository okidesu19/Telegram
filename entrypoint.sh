#!/bin/bash
set -e

mkdir -p /home/source/TMessagesProj/build/outputs/apk && \
mkdir -p /home/gradle/TMessagesProj/build/outputs/bundle && \
mkdir -p /home/source/TMessagesProj/build/outputs/native-debug-symbols && \
cp -R /home/source/. /home/gradle && \
cd /home/gradle && \
gradle :TMessagesProj_App:bundleBundleAfat_SDK23Release && \
gradle :TMessagesProj_App:bundleBundleAfatRelease && \
gradle :TMessagesProj_AppStandalone:assembleAfatStandalone && \
gradle :TMessagesProj_App:assembleAfatRelease && \
gradle :TMessagesProj_AppHuawei:assembleAfatRelease && \
cp -R /home/gradle/TMessagesProj_App/build/outputs/apk/. /home/source/TMessagesProj/build/outputs/apk && \
cp -R /home/gradle/TMessagesProj_AppHuawei/build/outputs/apk/. /home/source/TMessagesProj/build/outputs/apk && \
cp -R /home/gradle/TMessagesProj_AppStandalone/build/outputs/apk/. /home/source/TMessagesProj/build/outputs/apk && \
cp -R /home/gradle/TMessagesProj_App/build/outputs/bundle/. /home/source/TMessagesProj/build/outputs/bundle
