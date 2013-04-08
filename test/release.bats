#!/usr/bin/env bats

load test_helper

create_release() {
  mkdir -p "${ERLENV_ROOT}/releases/$1"
}

setup() {
  mkdir -p "$ERLENV_TEST_DIR"
  cd "$ERLENV_TEST_DIR"
}

@test "no release selected" {
  assert [ ! -d "${ERLENV_ROOT}/releases" ]
  run erlenv-release
  assert_success "system (set by ${ERLENV_ROOT}/release)"
}

@test "set by ERLENV_RELEASE" {
  create_release "r16b"
  ERLENV_RELEASE=r16b run erlenv-release
  assert_success "r16b (set by ERLENV_RELEASE environment variable)"
}

@test "set by local file" {
  create_release "r16b"
  cat > ".erlang-release" <<<"r16b"
  run erlenv-release
  assert_success "r16b (set by ${PWD}/.erlang-release)"
}

@test "set by global file" {
  create_release "r16b"
  cat > "${ERLENV_ROOT}/release" <<<"r16b"
  run erlenv-release
  assert_success "r16b (set by ${ERLENV_ROOT}/release)"
}
