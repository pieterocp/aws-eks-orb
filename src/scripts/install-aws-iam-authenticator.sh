#!/bin/bash
if which aws-iam-authenticator > /dev/null; then
    echo "AWS IAM Authenticator for Kubernetes is already installed"
    exit 0
fi
PLATFORM="linux"
if uname | grep -q 'Darwin' 
then
    PLATFORM="darwin"
fi
FILENAME="aws-iam-authenticator"
VERSION=0.5.6
if [ -n "${ORB_VAL_RELEASE_TAG}" ]; then
    export RELEASE_TAG=${ORB_VAL_RELEASE_TAG}
    VERSION="${RELEASE_TAG}"
    if [ "${VERSION}" == "0.3.0" ]; then
    FILENAME="heptio-authenticator-aws"
    fi
fi

DOWNLOAD_URL="https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${VERSION}/${FILENAME}_${VERSION}_${PLATFORM}_amd64"

printf "Downloading version %s\n"  "${VERSION}"

curl -L --fail --retry 3 -o aws-iam-authenticator "$DOWNLOAD_URL"
chmod +x ./aws-iam-authenticator

if [ "$(id -u)" -ne 0 ] && which sudo > /dev/null ; then
    SUDO="sudo"
fi
$SUDO mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator
