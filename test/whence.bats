#!/usr/bin/env bats

load test_helper

create_executable() {
  local bin="${ERLENV_ROOT}/releases/${1}/bin"
  mkdir -p "$bin"
  touch "${bin}/$2"
  chmod +x "${bin}/$2"
}

@test "finds releases where present" {
  create_executable "r15b" "erl"
  create_executable "r15b" "erlc"
  create_executable "r16b" "erl"
  create_executable "r16b" "typer"

  run erlenv-whence erl
  assert_success "\
    r15b
    r16b"

  run erlenv-whence erlc
  assert_success "r15b"

  run erlenv-whence typer
  assert_success "r16b"
}
