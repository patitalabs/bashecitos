#!/usr/bin/env bash

# local version: 1.1.0.0

@test "Setup macOS!" {
  run bash ../scripts/setup-macos-test.sh

  (( status == 0 ))

}