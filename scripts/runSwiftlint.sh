#!/bin/sh

if which swiftlint >/dev/null; then
    swiftlint
else
    echo "SwiftLint not installed, download from https://github.com/realm/SwiftLint"
    exit 1;
fi