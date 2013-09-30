#!/usr/bin/env bats

load test_helper

create_executable() {
  local bin="${ERLENV_ROOT}/releases/${1}/bin"
  mkdir -p "$bin"
  touch "${bin}/$2"
  chmod +x "${bin}/$2"
}

@test "empty rehash" {
  assert [ ! -d "${ERLENV_ROOT}/shims" ]
  run erlenv-rehash
  assert_success ""
  assert [ -d "${ERLENV_ROOT}/shims" ]
  rmdir "${ERLENV_ROOT}/shims"
}

@test "non-writable shims directory" {
  mkdir -p "${ERLENV_ROOT}/shims"
  chmod -w "${ERLENV_ROOT}/shims"
  run erlenv-rehash
  assert_failure "erlenv: cannot rehash: ${ERLENV_ROOT}/shims isn't writable"
}

@test "rehash in progress" {
  mkdir -p "${ERLENV_ROOT}/shims"
  touch "${ERLENV_ROOT}/shims/.erlenv-shim"
  run erlenv-rehash
  assert_failure "erlenv: cannot rehash: ${ERLENV_ROOT}/shims/.erlenv-shim exists"
}

@test "creates shims" {
  create_executable "r15b" "erl"
  create_executable "r15b" "erlc"
  create_executable "r16b" "erl"
  create_executable "r16b" "typer"

  assert [ ! -e "${ERLENV_ROOT}/shims/erl" ]
  assert [ ! -e "${ERLENV_ROOT}/shims/erlc" ]
  assert [ ! -e "${ERLENV_ROOT}/shims/typer" ]

  run erlenv-rehash
  assert_success ""

  run ls "${ERLENV_ROOT}/shims"
  assert_success
  assert_output <<OUT
erl
erlc
typer
OUT
}

@test "removes stale shims" {
  mkdir -p "${ERLENV_ROOT}/shims"
  touch "${ERLENV_ROOT}/shims/oldshim1"
  chmod +x "${ERLENV_ROOT}/shims/oldshim1"

  create_executable "r16b" "erl"
  create_executable "r16b" "erlc"

  run erlenv-rehash
  assert_success ""

  assert [ ! -e "${ERLENV_ROOT}/shims/oldshim1" ]
}

@test "binary install locations containing spaces" {
  create_executable "dirname1 r16a" "erl"
  create_executable "dirname2 r16b" "erlc"

  assert [ ! -e "${ERLENV_ROOT}/shims/erl" ]
  assert [ ! -e "${ERLENV_ROOT}/shims/erlc" ]

  run erlenv-rehash
  assert_success ""

  run ls "${ERLENV_ROOT}/shims"
  assert_success
  assert_output <<OUT
erl
erlc
OUT
}

@test "carries original IFS within hooks" {
  hook_path="${ERLENV_TEST_DIR}/erlenv.d"
  mkdir -p "${hook_path}/rehash"
  cat > "${hook_path}/rehash/hello.bash" <<SH
hellos=(\$(printf "hello\\tugly world\\nagain"))
echo HELLO="\$(printf ":%s" "\${hellos[@]}")"
exit
SH

  ERLENV_HOOK_PATH="$hook_path" IFS=$' \t\n' run erlenv-rehash
  assert_success
  assert_output "HELLO=:hello:ugly:world:again"
}

@test "sh-rehash in bash" {
  create_executable "r16b" "erl"
  SHELL=/bin/bash run erlenv-sh-rehash
  assert_success "hash -r 2>/dev/null || true"
  assert [ -x "${ERLENV_ROOT}/shims/erl" ]
}

@test "sh-rehash in fish" {
  create_executable "r16b" "erl"
  SHELL=/usr/bin/fish run erlenv-sh-rehash
  assert_success "hash -r 2>/dev/null ; or true"
  assert [ -x "${ERLENV_ROOT}/shims/erl" ]
}
