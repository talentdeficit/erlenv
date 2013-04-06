#!/usr/bin/env bats

load test_helper

create_executable() {
  name="${1?}"
  shift 1
  bin="${ERLENV_ROOT}/releases/${ERLENV_RELEASE}/bin"
  mkdir -p "$bin"
  { if [ $# -eq 0 ]; then cat -
    else echo "$@"
    fi
  } | sed -Ee '1s/^ +//' > "${bin}/$name"
  chmod +x "${bin}/$name"
}

@test "fails with invalid version" {
  export ERLENV_RELEASE="R1B"
  run erlenv-exec erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().'  -noshell
  assert_failure "erlenv: release \`R1B' is not installed"
}

@test "completes with names of executables" {
  export ERLENV_RELEASE="R1B"
  create_executable "erl" "#!/bin/sh"
  create_executable "rebar" "#!/bin/sh"

  erlenv-rehash
  run erlenv-completions exec
  assert_success
  assert_output <<OUT
erl
rebar
OUT
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
  create_executable "erl" <<SH
#!$BASH
echo \$0
for arg; do
  # hack to avoid bash builtin echo which can't output '-e'
  printf "  %s\\n" "\$arg"
done
SH

  run erlenv-exec erl +K true +P 134217727 -- extra
  assert_success
	assert_output <<OUT
${ERLENV_ROOT}/releases/R1B/bin/erl
  +K
  true
  +P
  134217727
  --
  extra
OUT
}

