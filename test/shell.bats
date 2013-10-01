#!/usr/bin/env bats

load test_helper

@test "no shell release" {
  mkdir -p "${ERLENV_TEST_DIR}/myproject"
  cd "${ERLENV_TEST_DIR}/myproject"
  echo "1.2.3" > .erlang-release
  ERLENV_RELEASE="" run erlenv-sh-shell
  assert_failure "erlenv: no shell-specific release configured"
}

@test "shell release" {
  SHELL=/bin/bash ERLENV_RELEASE="1.2.3" run erlenv-sh-shell
  assert_success 'echo "$ERLENV_RELEASE"'
}

@test "shell version (fish)" {
  SHELL=/usr/bin/fish ERLENV_RELEASE="1.2.3" run erlenv-sh-shell
  assert_success 'echo "$ERLENV_RELEASE"'
}

@test "shell unset" {
  SHELL=/bin/bash run erlenv-sh-shell --unset
  assert_success "unset ERLENV_RELEASE"
}

@test "shell unset (fish)" {
  SHELL=/usr/bin/fish run erlenv-sh-shell --unset
  assert_success "set -e ERLENV_RELEASE"
}

@test "shell change invalid release" {
  run erlenv-sh-shell 1.2.3
  assert_failure
  assert_output <<SH
erlenv: release \`1.2.3' not installed
false
SH
}

@test "shell change release" {
  mkdir -p "${ERLENV_ROOT}/releases/1.2.3"
  SHELL=/bin/bash run erlenv-sh-shell 1.2.3
  assert_success 'export ERLENV_RELEASE="1.2.3"'
}

@test "shell change version (fish)" {
  mkdir -p "${ERLENV_ROOT}/releases/1.2.3"
  SHELL=/usr/bin/fish run erlenv-sh-shell 1.2.3
  assert_success 'setenv ERLENV_RELEASE "1.2.3"'
}
