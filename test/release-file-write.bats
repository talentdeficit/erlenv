#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$ERLENV_TEST_DIR"
  cd "$ERLENV_TEST_DIR"
}

@test "invocation without 2 arguments prints usage" {
  run erlenv-release-file-write
  assert_failure "Usage: erlenv release-file-write <file> <release>"
  run erlenv-release-file-write "one" ""
  assert_failure
}

@test "setting nonexistent release fails" {
  assert [ ! -e ".erlang-release" ]
  run erlenv-release-file-write ".erlang-release" "r16c"
  assert_failure "erlenv: release \`r16c' not installed"
  assert [ ! -e ".erlang-release" ]
}

@test "writes value to arbitrary file" {
  mkdir -p "${ERLENV_ROOT}/releases/r16c"
  assert [ ! -e "my-version" ]
  run erlenv-release-file-write "${PWD}/my-version" "r16c"
  assert_success ""
  assert [ "$(cat my-version)" = "r16c" ]
}
