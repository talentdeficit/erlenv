#!/usr/bin/env bats

load test_helper

create_executable() {
  bin="${ERLENV_ROOT}/releases/${ERLENV_RELEASE}/bin"
  mkdir -p "$bin"
  echo "$2" > "${bin}/$1"
  chmod +x "${bin}/$1"
}

@test "fails with invalid version" {
  export ERLENV_RELEASE="R1B"
  run erlenv-exec erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().'  -noshell
  assert_failure "erlenv: release \`R1B' is not installed"
}

@test "completes with names of executables" {
  export ERLENV_RELEASE="R1B"
  create_executable "erl"
  create_executable "rebar"

  erlenv-rehash
  run erlenv-completions exec
  assert_success
  assert_line 0 "erl"
  assert_line 1 "rebar"
  refute_line 2
}

@test "supports hook path with spaces" {
  hook_path="${ERLENV_TEST_DIR}/custom stuff/erlenv hooks"
  mkdir -p "${hook_path}/exec"
  echo "export HELLO='from hook'" > "${hook_path}/exec/hello.bash"

  export ERLENV_RELEASE=system
  ERLENV_HOOK_PATH="$hook_path" run erlenv-exec env
  assert_success
  assert_line "HELLO=from hook"
}

@test "forwards all arguments" {
  export ERLENV_RELEASE="R1B"
  create_executable "erl" "#!$BASH
    echo \$0
    while [[ \$# -gt 0 ]]; do
      # hack to avoid bash builtin echo which can't output '-e'
      cat <<<\"\$1\"
      shift 1
    done
    "

  run erlenv-exec erl +K true +P 134217727 -- extra
  assert_line 0 "${ERLENV_ROOT}/releases/R1B/bin/erl"
  assert_line 1 "+K"
  assert_line 2 "true"
  assert_line 3 "+P"
  assert_line 4 "134217727"
  assert_line 5 "--"
  assert_line 6 "extra"
  refute_line 7
}
