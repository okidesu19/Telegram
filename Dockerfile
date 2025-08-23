FROM gradle:8.6.0-jdk17

ENV ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip \
    ANDROID_API_LEVEL=android-34 \
    ANDROID_BUILD_TOOLS_VERSION=34.0.0 \
    ANDROID_HOME=/usr/local/android-sdk-linux \
    ANDROID_NDK_VERSION=21.4.7075529 \
    ANDROID_VERSION=34 \
    ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/${ANDROID_NDK_VERSION}/ \
    PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install Android SDK
RUN mkdir -p "$ANDROID_HOME" .android && \
    cd "$ANDROID_HOME" && \
    curl -o sdk.zip "$ANDROID_SDK_URL" && \
    unzip -q sdk.zip && \
    rm sdk.zip

# Accept licenses and install Android components
RUN yes | ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME --licenses && \
    ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME --update && \
    ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME \
        "build-tools;30.0.3" \
        "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
        "platforms;android-${ANDROID_VERSION}" \
        "platform-tools" \
        "ndk;${ANDROID_NDK_VERSION}"

# Copy dx files
RUN cp "${ANDROID_HOME}/build-tools/30.0.3/dx" "${ANDROID_HOME}/build-tools/34.0.0/dx" && \
    cp "${ANDROID_HOME}/build-tools/30.0.3/lib/dx.jar" "${ANDROID_HOME}/build-tools/34.0.0/lib/dx.jar"

# Add NDK to PATH
ENV PATH=${ANDROID_NDK_HOME}:${PATH} \
    PATH=${ANDROID_NDK_HOME}/prebuilt/linux-x86_64/bin/:${PATH}

# Create entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
