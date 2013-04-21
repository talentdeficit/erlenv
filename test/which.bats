#!/usr/bin/env bats

load test_helper

create_executable() {
  local bin
  if [[ $1 == */* ]]; then bin="$1"
  else bin="${ERLENV_ROOT}/releases/${1}/bin"
  fi
  mkdir -p "$bin"
  touch "${bin}/$2"
  chmod +x "${bin}/$2"
}

@test "outputs path to executable" {
  create_executable "r15b" "erl"
  create_executable "r16b" "erlc"

  ERLENV_RELEASE=r15b run erlenv-which erl
  assert_success "${ERLENV_ROOT}/releases/r15b/bin/erl"

  ERLENV_RELEASE=r16b run erlenv-which erlc
  assert_success "${ERLENV_ROOT}/releases/r16b/bin/erlc"
}

@test "searches PATH for system release" {
  create_executable "${ERLENV_TEST_DIR}/bin" "kill-all-humans"
  create_executable "${ERLENV_ROOT}/shims" "kill-all-humans"

  ERLENV_RELEASE=system run erlenv-which kill-all-humans
  assert_success "${ERLENV_TEST_DIR}/bin/kill-all-humans"
}

@test "release not installed" {
  create_executable "r15b" "rebar"
  ERLENV_RELEASE=r16b run erlenv-which rebar
  assert_failure "erlenv: release \`r16b' is not installed"
}

@test "no executable found" {
  create_executable "r15b" "rebar"
  ERLENV_RELEASE=r15b run erlenv-which dialyzer
  assert_failure "erlenv: dialyzer: command not found"
}

@test "executable found in other versions" {
  create_executable "r15b" "erl"
  create_executable "r16b" "rebar"
  create_executable "r17a" "rebar"

  ERLENV_RELEASE=r15b run erlenv-which rebar
  assert_failure
	assert_output <<OUT
erlenv: rebar: command not found

The \`rebar' command exists in these erlang releases:
  r16b
  r17a
OUT
}

@test "carries original IFS within hooks" {
  hook_path="${ERLENV_TEST_DIR}/erlenv.d"
  mkdir -p "${hook_path}/which"
  cat > "${hook_path}/which/hello.bash" <<SH
hellos=(\$(printf "hello\\tugly world\\nagain"))
echo HELLO="\$(printf ":%s" "\${hellos[@]}")"
exit
SH

  ERLENV_HOOK_PATH="$hook_path" IFS=$' \t\n' run erlenv-which anything
  assert_success
  assert_output "HELLO=:hello:ugly:world:again"
}
