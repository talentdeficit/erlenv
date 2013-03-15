#!/usr/bin/env bats

load test_helper

@test "blank invocation" {
  run erlenv
  assert_success
  assert [ "${lines[0]}" = "erlenv 0.4.0" ]
}

@test "invalid command" {
  run erlenv does-not-exist
  assert_failure
  assert_output "erlenv: no such command \`does-not-exist'"
}

@test "default ERLENV_ROOT" {
  ERLENV_ROOT="" HOME=/home/testuser run erlenv root
  assert_success
  assert_output "/home/testuser/.erlenv"
}

@test "inherited ERLENV_ROOT" {
  ERLENV_ROOT=/opt/erlenv run erlenv root
  assert_success
  assert_output "/opt/erlenv"
}

@test "default ERLENV_DIR" {
  run erlenv echo ERLENV_DIR
  assert_output "$(pwd)"
}

@test "inherited ERLENV_DIR" {
  dir="${BATS_TMPDIR}/myproject"
  mkdir -p "$dir"
  ERLENV_DIR="$dir" run erlenv echo ERLENV_DIR
  assert_output "$dir"
}

@test "invalid ERLENV_DIR" {
  dir="${BATS_TMPDIR}/does-not-exist"
  assert [ ! -d "$dir" ]
  ERLENV_DIR="$dir" run erlenv echo ERLENV_DIR
  assert_failure
  assert_output "erlenv: cannot change working directory to \`$dir'"
}
