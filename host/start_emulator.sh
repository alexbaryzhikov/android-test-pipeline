#!/bin/bash

wait_emulator_boot() {
    adb devices | grep emulator | cut -f1 | while read line; do adb -s $line emu kill; done
    emulator -avd test-pixel -no-audio -no-boot-anim -no-window -accel on -gpu auto &

    boot_completed=false
    while [ "$boot_completed" == false ]; do
        status=$(adb wait-for-device shell getprop sys.boot_completed | tr -d '\r')
        if [ "$status" == "1" ]; then
            echo "Boot Status: online"
            boot_completed=true
        else
            echo "Boot Status: loading..."
            sleep 1
        fi
    done
}

disable_animation() {
    adb shell "settings put global window_animation_scale 0.0"
    adb shell "settings put global transition_animation_scale 0.0"
    adb shell "settings put global animator_duration_scale 0.0"
}

wait_emulator_boot
sleep 1
disable_animation
