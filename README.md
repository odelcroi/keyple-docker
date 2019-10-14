# Keyple CI : docker container 

## Gradle container
use java8 container
last tag : gradle2

## Android container
use gradle container
last tag : android2

## PGP container
use android container
allows to publish to sonatype
last tag : pgp2


# Docker commands

in ./eclipse/ folder

```
 docker build -t eclipsekeyple/build:pgp2 -f ./pgp/Dockerfile .
```

```
docker run eclipsekeyple/build:pgp2 -it /bin/bash
```


to push an image to eclipsekeyple/build dockerhub repo, you need to sign in with 

```
docker login
```
then you can push a tagged image
```
docker push eclipsekeyple/build:pgp2
```

