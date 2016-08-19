#!/bin/sh
# from https://github.com/SvenDowideit/docs-automation/tree/master/jenkins

JUSER="jenkins"

DOCKER_GID=$(ls -aln /var/run/docker.sock  | awk '{print $4}')

if ! getent group $DOCKER_GID; then
	echo creating docker group $DOCKER_GID
	addgroup --gid $DOCKER_GID docker
fi

if ! getent group $GID; then
	echo creating $JUSER group $GID
	addgroup --gid $GID $JUSER
fi

if ! getent passwd $JUSER; then
	echo useradd -N --gid $GID -u $UID $JUSER
	useradd -N --gid $GID -u $UID $JUSER
fi

DOCKER_GROUP=$(ls -al /var/run/docker.sock  | awk '{print $4}')
if ! id -nG "$JUSER" | grep -qw "$DOCKER_GROUP"; then
	adduser $JUSER $DOCKER_GROUP
fi

exec su $JUSER -c "/usr/local/bin/jenkins-slave $@"
