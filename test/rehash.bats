#!/usr/bin/env bats

load test_helper

@test "empty rehash" {
  assert [ ! -d "${ERLENV_ROOT}/shims" ]
  run erlenv-rehash
  assert_success
  assert [ -d "${ERLENV_ROOT}/shims" ]
  rmdir "${ERLENV_ROOT}/shims"
}

@test "non-writable shims directory" {
  mkdir -p "${ERLENV_ROOT}/shims"
  chmod -w "${ERLENV_ROOT}/shims"
  run erlenv-rehash
  assert_failure
  assert_output "erlenv: cannot rehash: ${ERLENV_ROOT}/shims isn't writable"
}

@test "rehash in progress" {
  mkdir -p "${ERLENV_ROOT}/shims"
  touch "${ERLENV_ROOT}/shims/.erlenv-shim"
  run erlenv-rehash
  assert_failure
  assert_output "erlenv: cannot rehash: ${ERLENV_ROOT}/shims/.erlenv-shim exists"
}
