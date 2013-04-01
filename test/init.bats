#!/usr/bin/env bats

load test_helper

@test "creates shims and releases directories" {
  assert [ ! -d "${ERLENV_ROOT}/shims" ]
  assert [ ! -d "${ERLENV_ROOT}/releases" ]
  run erlenv-init -
  assert_success
  assert [ -d "${ERLENV_ROOT}/shims" ]
  assert [ -d "${ERLENV_ROOT}/releases" ]
}

@test "auto rehash" {
  run erlenv-init -
  assert_success
  assert_line "erlenv rehash 2>/dev/null"
}

@test "setup shell completions" {
  export SHELL=/bin/bash
  root="$(cd $BATS_TEST_DIRNAME/.. && pwd)"
  run erlenv-init -
  assert_success
  assert_line 'source "'${root}'/libexec/../completions/erlenv.bash"'
}

@test "option to skip rehash" {
  run erlenv-init - --no-rehash
  assert_success
  refute_line "erlenv rehash 2>/dev/null"
}

@test "adds shims to PATH" {
  export PATH="${BATS_TEST_DIRNAME}/../libexec:/usr/bin:/bin"
  run erlenv-init -
  assert_success
  assert_line 0 'export PATH="'${ERLENV_ROOT}'/shims:${PATH}"'
}

@test "doesn't add shims to PATH more than once" {
  export PATH="${ERLENV_ROOT}/shims:$PATH"
  run erlenv-init -
  assert_success
  refute_line 'export PATH="'${ERLENV_ROOT}'/shims:${PATH}"'
}
