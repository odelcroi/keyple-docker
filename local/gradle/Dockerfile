#eclipsekeyple/build:gradlelocal
FROM openjdk:8-jdk

WORKDIR /opt/


# Set up environment variables
ENV USER_NAME="jenkins"
ENV HOME="/home/${USER_NAME}"
RUN whoami


#gradle2
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
ENV PATH="${GRADLE_HOME}/bin:${PATH}"

