#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$ERLENV_TEST_DIR"
  cd "$ERLENV_TEST_DIR"
}

@test "reports global file even if it doesn't exist" {
  assert [ ! -e "${ERLENV_ROOT}/release" ]
  run erlenv-release-origin
  assert_success "${ERLENV_ROOT}/release"
}

@test "detects global file" {
  mkdir -p "$ERLENV_ROOT"
  touch "${ERLENV_ROOT}/release"
  run erlenv-release-origin
  assert_success "${ERLENV_ROOT}/release"
}

@test "detects ERLENV_RELEASE" {
  ERLENV_RELEASE=1 run erlenv-release-origin
  assert_success "ERLENV_RELEASE environment variable"
}

@test "detects local file" {
  touch .erlang-release
  run erlenv-release-origin
  assert_success "${PWD}/.erlang-release"
}
