#!/usr/bin/env bats

load test_helper

create_executable() {
  bin="${ERLENV_ROOT}/releases/${ERLENV_VERSION}/bin"
  mkdir -p "$bin"
  echo "$2" > "${bin}/$1"
  chmod +x "${bin}/$1"
}

@test "fails with invalid version" {
  export ERLENV_RELEASE="R1"
  run erlenv-exec erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().'  -noshell
  assert_failure "erlenv: release \`R1' is not installed"
}

@test "completes with names of executables" {
  export ERLENV_VERSION="R1"
  create_executable "erl"
  create_executable "erlc"

  erlenv-rehash
  run erlenv-completions exec
  assert_success
  assert_line 0 "erl"
  assert_line 1 "erlc"
  refute_line 2
}

@test "supports hook path with spaces" {
  hook_path="${ERLENV_TEST_DIR}/custom stuff/erlenv hooks"
  mkdir -p "${hook_path}/exec"
  echo "export HELLO='from hook'" > "${hook_path}/exec/hello.bash"

  export ERLENV_VERSION=system
  ERLENV_HOOK_PATH="$hook_path" run erlenv-exec env
  assert_success
  assert_line "HELLO=from hook"
}
