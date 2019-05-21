#eclipsekeyple/build:pgp1
FROM eclipsekeyple/build:android2

#Remove gnupg version 2 and install gnupg version 1
RUN apt-get update \
    && apt-get remove -y  gnupg \
    && apt-get install -y gnupg1 \
    && gpg1 --version
#end of gradle

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
COPY docker_scripts/uid_entrypoint /usr/local/bin/uid_entrypoint
RUN chmod u+x /usr/local/bin/uid_entrypoint && \
    chgrp 0 /usr/local/bin/uid_entrypoint && \
    chmod g=u /usr/local/bin/uid_entrypoint /etc/passwd
### end

ENTRYPOINT [ "/usr/local/bin/uid_entrypoint" ]



