#!/usr/bin/env bats

load test_helper

create_hook() {
  mkdir -p "$1/$2"
  touch "$1/$2/$3"
}

@test "prints usage help given no argument" {
  run erlenv-hooks
  assert_failure "Usage: erlenv hooks <command>"
}

@test "prints list of hooks" {
  path1="${ERLENV_TEST_DIR}/erlenv.d"
  path2="${ERLENV_TEST_DIR}/etc/erlenv_hooks"
  create_hook "$path1" exec "hello.bash"
  create_hook "$path1" exec "ahoy.bash"
  create_hook "$path1" exec "invalid.sh"
  create_hook "$path1" which "boom.bash"
  create_hook "$path2" exec "bueno.bash"

<<<<<<< HEAD
  ERLENV_HOOK_PATH="$path1:$path2" run erlenv-hooks exec
  assert_success "\
    ${ERLENV_TEST_DIR}/erlenv.d/exec/ahoy.bash
    ${ERLENV_TEST_DIR}/erlenv.d/exec/hello.bash
    ${ERLENV_TEST_DIR}/etc/erlenv_hooks/exec/bueno.bash"
}

@test "supports hook paths with spaces" {
  path1="${ERLENV_TEST_DIR}/my hooks/erlenv.d"
  path2="${ERLENV_TEST_DIR}/etc/erlenv hooks"
  create_hook "$path1" exec "hello.bash"
  create_hook "$path2" exec "ahoy.bash"

<<<<<<< HEAD
  ERLENV_HOOK_PATH="$path1:$path2" run erlenv-hooks exec
  assert_success "\
    ${ERLENV_TEST_DIR}/my hooks/erlenv.d/exec/hello.bash
    ${ERLENV_TEST_DIR}/etc/erlenv hooks/exec/ahoy.bash"
}

@test "resolves relative paths" {
  path="${ERLENV_TEST_DIR}/erlenv.d"
  create_hook "$path" exec "hello.bash"
  mkdir -p "$HOME"

  ERLENV_HOOK_PATH="${HOME}/../erlenv.d" run erlenv-hooks exec
  assert_success "${ERLENV_TEST_DIR}/erlenv.d/exec/hello.bash"
}

@test "resolves symlinks" {
  path="${ERLENV_TEST_DIR}/erlenv.d"
  mkdir -p "${path}/exec"
  mkdir -p "$HOME"
  touch "${HOME}/hola.bash"
  ln -s "../../home/hola.bash" "${path}/exec/hello.bash"

  ERLENV_HOOK_PATH="$path" run erlenv-hooks exec
  assert_success "${HOME}/hola.bash"
}
