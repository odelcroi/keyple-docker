#eclipsekeyple/build:android
FROM eclipsekeyple/build:gradle2

WORKDIR /opt/

# Set up environment variables
ENV USER_NAME="jenkins"
ENV HOME="/home/${USER_NAME}"

RUN whoami
#
# Download Android SDK
#
ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip"
ENV ANDROID_HOME="/opt/android-sdk-linux"

RUN mkdir "$ANDROID_HOME" .android \
 && cd "$ANDROID_HOME" \
 && curl -o sdk.zip $SDK_URL \
 && unzip sdk.zip \
 && rm sdk.zip \
 && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

### give rights to android_home folder
RUN chgrp -R 0 "$ANDROID_HOME" \
 && chmod -R g+w "$ANDROID_HOME"

#
# Configure PATH
#
ENV PATH="${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${PATH}"


### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
COPY docker_scripts/uid_entrypoint /usr/local/bin/uid_entrypoint
RUN chmod u+x /usr/local/bin/uid_entrypoint && \
    chgrp 0 /usr/local/bin/uid_entrypoint && \
    chmod @g=u /usr/local/bin/uid_entrypoint /etc/passwd
### end

ENTRYPOINT [ "/usr/local/bin/uid_entrypoint" ]



