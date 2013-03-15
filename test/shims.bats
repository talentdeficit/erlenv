#!/usr/bin/env bats

load test_helper

@test "no shims" {
  run erlenv-shims
  assert_success
  assert [ -z "$output" ]
}

@test "shims" {
  mkdir -p "${ERLENV_ROOT}/shims"
  touch "${ERLENV_ROOT}/shims/erl"
  touch "${ERLENV_ROOT}/shims/erlc"
  touch "${ERLENV_ROOT}/shims/dialyzer"
  run erlenv-shims
  assert_success
  assert_line "${ERLENV_ROOT}/shims/erl"
  assert_line "${ERLENV_ROOT}/shims/erlc"
  assert_line "${ERLENV_ROOT}/shims/dialyzer"
}

@test "shims --short" {
  mkdir -p "${ERLENV_ROOT}/shims"
  touch "${ERLENV_ROOT}/shims/erl"
  touch "${ERLENV_ROOT}/shims/erlc"
  touch "${ERLENV_ROOT}/shims/dialyzer"
  run erlenv-shims --short
  assert_success
  assert_line "erl"
  assert_line "erlc"
  assert_line "dialyzer"
}
