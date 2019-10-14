#FROM maven:3.6-jdk-8
FROM openjdk:8-jdk

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
# Install Gradle
#
ENV GRADLE_URL="https://services.gradle.org/distributions/gradle-4.5.1-bin.zip"
ENV GRADLE_HOME=/opt/gradle/gradle-4.5.1

RUN mkdir /opt/gradle .gradle \
 && cd /opt/gradle \
 && wget $GRADLE_URL -O gradle.zip \
 && unzip gradle.zip \
 && rm gradle.zip

RUN chmod u+x $GRADLE_HOME/bin/gradle && \
 chgrp -R 0 $GRADLE_HOME && \
 chmod -R g=u $GRADLE_HOME && \
 chmod -R g+w $GRADLE_HOME


#
# Configure PATH
#
ENV PATH="${GRADLE_HOME}/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${PATH}"

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
COPY docker_scripts/uid_entrypoint /usr/local/bin/uid_entrypoint
RUN chmod u+x /usr/local/bin/uid_entrypoint && \
    chgrp 0 /usr/local/bin/uid_entrypoint && \
    chmod g=u /usr/local/bin/uid_entrypoint /etc/passwd
### end


#
# Pre-Download dependencies
#
RUN git clone https://github.com/eclipse/keyple-java.git \
  && cd keyple-java \
  && gradle wrapper --gradle-version 4.5.1 \
  && gradle classes

ENTRYPOINT [ "/usr/local/bin/uid_entrypoint" ]

#USER 1000100000

