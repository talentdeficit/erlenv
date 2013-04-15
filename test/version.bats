#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HOME"
  git config --global user.name  "Tester"
  git config --global user.email "tester@test.local"
}

git_commit() {
  git commit --quiet --allow-empty -m "" --allow-empty-message
}

@test "default version" {
  assert [ ! -e "$ERLENV_ROOT" ]
  run erlenv-version
  assert_success
  [[ $output == "erlenv 0."* ]]
}

@test "reads version from git repo" {
  mkdir -p "$ERLENV_ROOT"
  cd "$ERLENV_ROOT"
  git init
  git_commit
  git tag v0.4.1
  git_commit
  git_commit

  cd "$ERLENV_TEST_DIR"
  run erlenv-version
  assert_success
  [[ $output == "erlenv 0.4.1-2-g"* ]]
}

@test "prints default version if no tags in git repo" {
  mkdir -p "$ERLENV_ROOT"
  cd "$ERLENV_ROOT"
  git init
  git_commit

  cd "$ERLENV_TEST_DIR"
  run erlenv-version
  [[ $output == "erlenv 0."* ]]
}
