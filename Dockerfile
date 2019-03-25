#tag eclipsekeyple/build:1
#FROM maven:3.6-jdk-8
FROM openjdk:8-jdk

# Create a non-root user
#RUN useradd -m user
#USER user
#WORKDIR /home/user

# Set up environment variables
ENV USER_NAME="user"
ENV HOME="/home/${USER_NAME}"
ENV ANDROID_HOME="${HOME}/android-sdk-linux"
ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip"
ENV GRADLE_URL="https://services.gradle.org/distributions/gradle-4.5.1-all.zip"

RUN mkdir -p ${HOME}
WORKDIR $HOME

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
 && cd "$ANDROID_HOME" \
 && curl -o sdk.zip $SDK_URL \
 && unzip sdk.zip \
 && rm sdk.zip \
 && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Install Gradle
RUN wget $GRADLE_URL -O gradle.zip \
 && unzip gradle.zip \
 && mv gradle-4.5.1 gradle \
 && rm gradle.zip \
 && mkdir .gradle

ENV PATH="${HOME}/gradle/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${PATH}"

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

RUN chmod u+x $HOME/gradle/bin/gradle
#RUN chmod u+x $HOME/gradle/bin/gradle && \
# chgrp 0 $HOME/.gradle && \
# chmod g=u $HOME/.gradle

RUN chgrp 0 -R $HOME && \
 chmod g=u -R $HOME

RUN git clone https://github.com/eclipse/keyple-java.git \
  && cd keyple-java \
  && gradle wrapper --gradle-version 4.5.1 \
  && gradle classes

ENTRYPOINT [ "/usr/local/bin/uid_entrypoint" ]

#USER 1000100000

