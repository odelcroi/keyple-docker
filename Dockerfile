#tag eclipsekeyple/build:1
#FROM maven:3.6-jdk-8
FROM openjdk:8-jdk

# Create a non-root user
#RUN useradd -m user
#USER user

WORKDIR /opt/

# Set up environment variables
ENV USER_NAME="jenkins"
ENV HOME="/home/${USER_NAME}"
ENV ANDROID_HOME="/opt/android-sdk-linux"
ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip"
ENV GRADLE_URL="https://services.gradle.org/distributions/gradle-4.5.1-bin.zip"

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
 && cd "$ANDROID_HOME" \
 && curl -o sdk.zip $SDK_URL \
 && unzip sdk.zip \
 && rm sdk.zip \
 && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Install Gradle
RUN mkdir /opt/gradle /opt/gradle/.gradle \
 && cd /opt/gradle \
 && wget $GRADLE_URL -O gradle.zip \
 && unzip gradle.zip \
 && rm gradle.zip

ENV GRADLE_HOME=/opt/gradle/gradle-4.5.1

ENV PATH="${GRADLE_HOME}/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${PATH}"

#USER root

### give rights to android_home folder
#RUN chgrp -R 0 "$ANDROID_HOME" \
# && chmod -R g=u "$ANDROID_HOME"

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
COPY docker_scripts/uid_entrypoint /usr/local/bin/uid_entrypoint
RUN chmod u+x /usr/local/bin/uid_entrypoint && \
    chgrp 0 /usr/local/bin/uid_entrypoint && \
    chmod g=u /usr/local/bin/uid_entrypoint /etc/passwd
### end

RUN chmod u+x $GRADLE_HOME/bin/gradle && \
 chgrp 0 $GRADLE_HOME && \
 chmod g=u $GRADLE_HOME

RUN git clone https://github.com/eclipse/keyple-java.git \
  && cd keyple-java \
  && gradle wrapper --gradle-version 4.5.1 \
  && gradle classes

ENTRYPOINT [ "/usr/local/bin/uid_entrypoint" ]

#USER 1000100000

