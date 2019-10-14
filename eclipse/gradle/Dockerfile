#eclipsekeyple/build:gradle2
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

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
COPY docker_scripts/uid_entrypoint /usr/local/bin/uid_entrypoint
RUN chmod u+x /usr/local/bin/uid_entrypoint && \
    chgrp 0 /usr/local/bin/uid_entrypoint && \
    chmod g=u /usr/local/bin/uid_entrypoint /etc/passwd
### end

#
# Pre-Download dependencies
#
ENV TMP_PROJECT="/tmp/project"
RUN mkdir $TMP_PROJECT
RUN cd $TMP_PROJECT \
  && git clone https://github.com/eclipse/keyple-java.git \
  && cd keyple-java \
  && gradle wrapper --gradle-version 4.5.1 -i \
  && gradle classes -i

ENTRYPOINT [ "/usr/local/bin/uid_entrypoint" ]



