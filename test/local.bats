#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "${ERLENV_TEST_DIR}/myproject"
  cd "${ERLENV_TEST_DIR}/myproject"
}

@test "no release" {
  assert [ ! -e "${PWD}/.erlang-release" ]
  run erlenv-local
  assert_failure "erlenv: no local release configured for this directory"
}

@test "local release" {
  echo "1.2.3" > .erlang-release
  run erlenv-local
  assert_success "1.2.3"
}

@test "ignores release in parent directory" {
  echo "1.2.3" > .erlang-release

  mkdir -p "subdir" && cd "subdir"
  run erlenv-local
  assert_failure
}

@test "ignores ERLENV_DIR" {
  echo "1.2.3" > .erlang-release
  mkdir -p "$HOME"
  echo "2.0-home" > "${HOME}/.erlang-release"
  ERLENV_DIR="$HOME" run erlenv-local
  assert_success "1.2.3"
}

@test "sets local release" {
  mkdir -p "${ERLENV_ROOT}/releases/1.2.3"
  run erlenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .erlang-release)" = "1.2.3" ]
}

@test "changes local release" {
  echo "1.0-pre" > .erlang-release
  mkdir -p "${ERLENV_ROOT}/releases/1.2.3"
  run erlenv-local
  assert_success "1.0-pre"
  run erlenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .erlang-release)" = "1.2.3" ]
}

@test "unsets local release" {
  touch .erlang-release
  run erlenv-local --unset
  assert_success ""
  assert [ ! -e .erlang-release ]
}
