#!/usr/bin/env bats

load test_helper

create_version() {
  mkdir -p "${ERLENV_ROOT}/releases/$1"
}

setup() {
  mkdir -p "$ERLENV_TEST_DIR"
  cd "$ERLENV_TEST_DIR"
}

@test "no release selected" {
  assert [ ! -d "${ERLENV_ROOT}/releases" ]
  run erlenv-release-name
  assert_success "system"
}

@test "system release is not checked for existance" {
  ERLENV_RELEASE=system run erlenv-release-name
  assert_success "system"
}

@test "ERLENV_RELEASE has precedence over local" {
  create_version "r16b" 
	create_version "r16c"

  cat > ".erlang-release" <<<"r16b"
  run erlenv-release-name
  assert_success "r16b"

  ERLENV_RELEASE=r16c run erlenv-release-name
  assert_success "r16c"
}

@test "local file has precedence over global" {
  create_version "r16b"
  create_version "r16c"

  cat > "${ERLENV_ROOT}/release" <<<"r16b"
  run erlenv-release-name
  assert_success "r16b"

  cat > ".erlang-release" <<<"r16c"
  run erlenv-release-name
  assert_success "r16c"
}

@test "missing release" {
  ERLENV_RELEASE=r1b run erlenv-release-name
  assert_failure "erlenv: release \`r1b' is not installed"
}
