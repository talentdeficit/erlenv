#!/usr/bin/env bats

load test_helper

create_release() {
  mkdir -p "${ERLENV_ROOT}/releases/$1"
}

setup() {
  mkdir -p "$ERLENV_TEST_DIR"
  cd "$ERLENV_TEST_DIR"
}

@test "no releases installed" {
  assert [ ! -d "${ERLENV_ROOT}/releases" ]
  run erlenv-releases
  assert_success "* system (set by ${ERLENV_ROOT}/release)"
}

@test "bare output no releases installed" {
  assert [ ! -d "${ERLENV_ROOT}/releases" ]
  run erlenv-releases --bare
  assert_success ""
}

@test "single release installed" {
  create_release "r17a"
  run erlenv-releases
  assert_success
  assert_output <<OUT
* system (set by ${ERLENV_ROOT}/release)
  r17a
OUT
}

@test "single release bare" {
  create_release "r17a"
  run erlenv-releases --bare
  assert_success "r17a"
}

@test "multiple releases" {
  create_release "r15b"
  create_release "r16b"
  create_release "r17a"
	
  run erlenv-releases
  assert_success
  assert_output <<OUT
* system (set by ${ERLENV_ROOT}/release)
  r15b
  r16b
  r17a
OUT
}

@test "indicates current release" {
  create_release "r15b"
  create_release "r16b"
  ERLENV_RELEASE=r15b run erlenv-releases
  assert_success
  assert_output <<OUT
  system
* r15b (set by ERLENV_RELEASE environment variable)
  r16b
OUT
}

@test "bare doesn't indicate current release" {
  create_release "r15b"
  create_release "r16b"
  ERLENV_RELEASE=r15b run erlenv-releases --bare
  assert_success
  assert_output <<OUT
r15b
r16b
OUT
}

@test "globally selected release" {
  create_release "r15b"
  create_release "r16b"
  cat > "${ERLENV_ROOT}/release" <<<"r15b"
  run erlenv-releases
  assert_success
  assert_output <<OUT
  system
* r15b (set by ${ERLENV_ROOT}/release)
  r16b
OUT
}

@test "per-project release" {
  create_release "r15b"
  create_release "r16b"
  cat > ".erlang-release" <<<"r15b"
  run erlenv-releases
  assert_success
  assert_output <<OUT
  system
* r15b (set by ${ERLENV_TEST_DIR}/.erlang-release)
  r16b
OUT
}
