#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$ERLENV_TEST_DIR"
  cd "$ERLENV_TEST_DIR"
}

create_file() {
  mkdir -p "$(dirname "$1")"
  touch "$1"
}

@test "prints global file if no release files exist" {
  assert [ ! -e "${ERLENV_ROOT}/release" ]
  assert [ ! -e ".erlang-release" ]
  run erlenv-release-file
  assert_success "${ERLENV_ROOT}/release"
}

@test "detects 'global' file" {
  create_file "${ERLENV_ROOT}/global"
  run erlenv-release-file
  assert_success "${ERLENV_ROOT}/global"
}

@test "detects 'default' file" {
  create_file "${ERLENV_ROOT}/default"
  run erlenv-release-file
  assert_success "${ERLENV_ROOT}/default"
}

@test "'release' has precedence over 'global' and 'default'" {
  create_file "${ERLENV_ROOT}/release"
  create_file "${ERLENV_ROOT}/global"
  create_file "${ERLENV_ROOT}/default"
  run erlenv-release-file
  assert_success "${ERLENV_ROOT}/release"
}

@test "in current directory" {
  create_file ".erlang-release"
  run erlenv-release-file
  assert_success "${ERLENV_TEST_DIR}/.erlang-release"
}

@test "in parent directory" {
  create_file ".erlang-release"
  mkdir -p project
  cd project
  run erlenv-release-file
  assert_success "${ERLENV_TEST_DIR}/.erlang-release"
}

@test "topmost file has precedence" {
  create_file ".erlang-release"
  create_file "project/.erlang-release"
  cd project
  run erlenv-release-file
  assert_success "${ERLENV_TEST_DIR}/project/.erlang-release"
}

@test "ERLENV_DIR has precedence over PWD" {
  create_file "widget/.erlang-release"
  create_file "project/.erlang-release"
  cd project
  ERLENV_DIR="${ERLENV_TEST_DIR}/widget" run erlenv-release-file
  assert_success "${ERLENV_TEST_DIR}/widget/.erlang-release"
}

@test "PWD is searched if ERLENV_DIR yields no results" {
  mkdir -p "widget/blank"
  create_file "project/.erlang-release"
  cd project
  ERLENV_DIR="${ERLENV_TEST_DIR}/widget/blank" run erlenv-release-file
  assert_success "${ERLENV_TEST_DIR}/project/.erlang-release"
}
