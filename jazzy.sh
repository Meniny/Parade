#!/bin/bash

# Creates documentation using Jazzy.

FRAMEWORK_VERSION=1.0.0

jazzy \
  --clean \
  --author "Elias Abel" \
  --author_url https://meniny.cn \
  --github_url https://github.com/Meniny/Parade \
  --github-file-prefix https://github.com/Meniny/Parade/tree/$FRAMEWORK_VERSION \
  --module-version $FRAMEWORK_VERSION \
  --xcodebuild-arguments -scheme,"Parade iOS" \
  --module Parade \
  --root-url https://github.com/Meniny/Parade \
  --output Docs/
