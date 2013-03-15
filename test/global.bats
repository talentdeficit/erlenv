#!/usr/bin/env bats

load test_helper

@test "default" {
  run erlenv global
  assert_success
  assert_output "system"
}

@test "read ERLENV_ROOT/release" {
  mkdir -p "$ERLENV_ROOT"
  echo "1.2.3" > "$ERLENV_ROOT/release"
  run erlenv-global
  assert_success
  assert_output "1.2.3"
}

@test "set ERLENV_ROOT/release" {
  mkdir -p "$ERLENV_ROOT/releases/1.2.3"
  run erlenv-global "1.2.3"
  assert_success
  run erlenv global
  assert_success "1.2.3"
}

@test "fail setting invalid ERLENV_ROOT/release" {
  mkdir -p "$ERLENV_ROOT"
  run erlenv-global "1.2.3"
  assert_failure "erlenv: release \`1.2.3' not installed"
}
