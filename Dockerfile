FROM gradle:8.6.0-jdk17

ENV ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip
ENV ANDROID_API_LEVEL=android-34
ENV ANDROID_BUILD_TOOLS_VERSION=34.0.0
ENV ANDROID_HOME=/usr/local/android-sdk-linux
ENV ANDROID_NDK_VERSION=21.4.7075529
ENV ANDROID_VERSION=34
ENV ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/${ANDROID_NDK_VERSION}/
ENV PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install Android SDK
RUN mkdir "$ANDROID_HOME" .android && \
    cd "$ANDROID_HOME" && \
    curl -o sdk.zip $ANDROID_SDK_URL && \
    unzip sdk.zip && \
    rm sdk.zip

RUN yes | ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME --licenses && \
    ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME --update && \
    ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME \
        "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
        "platforms;android-${ANDROID_VERSION}" \
        "platform-tools" \
        "ndk;${ANDROID_NDK_VERSION}" && \

    rm -rf ${ANDROID_HOME}/cmdline-tools && \
    rm -rf ${ANDROID_HOME}/emulator && \
    rm -rf ${ANDROID_HOME}/system-images && \
    rm -rf ${ANDROID_HOME}/sources && \
    rm -rf ${ANDROID_HOME}/extras && \
    find ${ANDROID_HOME} -name "*examples*" -type d -prune -exec rm -rf {} \; && \

    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH=${ANDROID_NDK_HOME}:$PATH
ENV PATH=${ANDROID_NDK_HOME}/prebuilt/linux-x86_64/bin/:$PATH

CMD ["/bin/sh", "-c", "
    mkdir -p /home/source/TMessagesProj/build/outputs/apk && 
    mkdir -p /home/gradle/TMessagesProj/build/outputs/bundle && 
    mkdir -p /home/source/TMessagesProj/build/outputs/native-debug-symbols && 
    cp -R /home/source/. /home/gradle && 
    cd /home/gradle && 
    # Clean gradle cache before build
    ./gradlew clean && 
    # Run only essential build tasks
    ./gradlew :TMessagesProj_App:assembleAfatRelease && 
    ./gradlew :TMessagesProj_AppHuawei:assembleAfatRelease && 
    ./gradlew :TMessagesProj_AppStandalone:assembleAfatStandalone && 
    # Copy outputs
    cp -R /home/gradle/TMessagesProj_App/build/outputs/apk/. /home/source/TMessagesProj/build/outputs/apk && 
    cp -R /home/gradle/TMessagesProj_AppHuawei/build/outputs/apk/. /home/source/TMessagesProj/build/outputs/apk && 
    cp -R /home/gradle/TMessagesProj_AppStandalone/build/outputs/apk/. /home/source/TMessagesProj/build/outputs/apk && 
    cp -R /home/gradle/TMessagesProj_App/build/outputs/bundle/. /home/source/TMessagesProj/build/outputs/bundle
"]
