#!/bin/bash

# Image has to be built and used by the same runner. This is because
# user and kvm group in the conainer must reflect that of the host.
# Users must have the same ID, otherwise host will have trouble with
# files ownership. kvm group ID inside container must match that of
# the host, otherwise Android emulator won't be able to start.

if [ $(grep -Ec '(vmx|svm)' /proc/cpuinfo) -eq 0 ]; then
    >&2 echo "Error: CPU hardware virtualization is not allowed"
    exit 1
fi

if [ -z $(getent group kvm) ]; then
    >&2 echo "Error: kvm group not found"
    exit 1
fi

PREFIX="android-test"
TAG=$(git describe --tags --always)
USER_ID=$(id -u $USER)
GROUP_ID=$(id -g $USER)
KVM_GROUP_ID=$(getent group kvm | cut -d: -f3)
ANDROID_API_LEVEL=29
ANDROID_BUILD_TOOLS_LEVEL=29.0.3
GRADLE_VERSION=6.5
COMMAND_LINE_TOOLS_VERSION=6609375_latest

echo "IMAGE=$PREFIX:$TAG USER_ID=$USER_ID GROUP_ID=$GROUP_ID KVM_GROUP_ID=$KVM_GROUP_ID"

docker build \
    --build-arg USER_ID=$USER_ID \
    --build-arg GROUP_ID=$GROUP_ID \
    --build-arg KVM_GROUP_ID=$KVM_GROUP_ID \
    --build-arg ANDROID_API_LEVEL=$ANDROID_API_LEVEL \
    --build-arg ANDROID_BUILD_TOOLS_LEVEL=$ANDROID_BUILD_TOOLS_LEVEL \
    --build-arg GRADLE_VERSION=$GRADLE_VERSION \
    --build-arg COMMAND_LINE_TOOLS_VERSION=$COMMAND_LINE_TOOLS_VERSION \
    -t $PREFIX:$TAG .
