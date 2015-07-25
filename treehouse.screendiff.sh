#!/bin/bash

# Name of the applications
APP_NAME="Transitions"

# Bundle identifier for the application
BUNDLE_IDENTIFIER="nl.treehouse.snippets.Transitions"

# Name of the build scheme to use
BUILD_SCHEME="Debug"

# Name of the SDK to build the application with
# Use 'xcodebuild -showsdks' to list available simulators
TARGET_SDK="iphonesimulator8.3"

# Name of the simulator to run the application on
# Use 'xcrun instruments -s' to list available simulators
TARGET_SIMULATOR="iPhone 5 (8.3 Simulator)"

# Location of the test automation script
AUTOMATION_SCRIPT_PATH="AutomationScripts"

# File name of the test automation script
AUTOMATION_SCRIPT_FILE="screencaptures.js"