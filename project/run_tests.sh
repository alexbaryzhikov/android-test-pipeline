#!/bin/bash

if [ "$(grep -Ec '(vmx|svm)' /proc/cpuinfo)" -eq 0 ]; then
    >&2 echo "Error: CPU hardware virtualization is not allowed"
    exit 1
fi

DOCKER_IMAGE="android-test:image-14-g7108ec3"

source $HOME/keystore/credentials

docker run --privileged -i --rm \
    -v "$PWD:/project" \
    -v "$HOME/sokb-keystore:/keystore" \
    -e ANDROID_KEYSTORE="/keystore/keystore" \
    -e ANDROID_KEYSTORE_PASS="$ANDROID_KEYSTORE_PASS" \
    -e ANDROID_KEYSTORE_ALIAS="$ANDROID_KEYSTORE_ALIAS" \
    -e ANDROID_KEYSTORE_ALIAS_PASS="$ANDROID_KEYSTORE_ALIAS_PASS" \
    $DOCKER_IMAGE \
    bash -c "/opt/start_emulator.sh && gradlew testDebugUnitAndAndroid -p /project"
