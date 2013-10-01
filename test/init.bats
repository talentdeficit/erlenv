#!/usr/bin/env bats

load test_helper

@test "creates shims and releases directories" {
  assert [ ! -d "${ERLENV_ROOT}/shims" ]
  assert [ ! -d "${ERLENV_ROOT}/releases" ]
  run erlenv-init -
  assert_success
  assert [ -d "${ERLENV_ROOT}/shims" ]
  assert [ -d "${ERLENV_ROOT}/releases" ]
}

@test "auto rehash" {
  run erlenv-init -
  assert_success
  assert_line "erlenv rehash 2>/dev/null"
}

@test "setup shell completions" {
  root="$(cd $BATS_TEST_DIRNAME/.. && pwd)"
  SHELL=/bin/bash run erlenv-init -
  assert_success
  assert_line ". '${root}/libexec/../completions/erlenv.bash'"
}

@test "setup shell completions (fish)" {
  root="$(cd $BATS_TEST_DIRNAME/.. && pwd)"
  SHELL=/usr/bin/fish run erlenv-init -
  assert_success
  assert_line ". '${root}/libexec/../completions/erlenv.fish'"
}

@test "option to skip rehash" {
  run erlenv-init - --no-rehash
  assert_success
  refute_line "erlenv rehash 2>/dev/null"
}

@test "adds shims to PATH" {
  export PATH="${BATS_TEST_DIRNAME}/../libexec:/usr/bin:/bin"
  SHELL=/bin/bash run erlenv-init -
  assert_success
  assert_line 0 'export PATH="'${ERLENV_ROOT}'/shims:${PATH}"'
}

@test "adds shims to PATH (fish)" {
  export PATH="${BATS_TEST_DIRNAME}/../libexec:/usr/bin:/bin"
  SHELL=/usr/bin/fish run erlenv-init -
  assert_success
  assert_line 0 "setenv PATH '${ERLENV_ROOT}/shims' \$PATH"
}

@test "doesn't add shims to PATH more than once" {
  export PATH="${ERLENV_ROOT}/shims:$PATH"
  SHELL=/bin/bash run erlenv-init -
  assert_success
  refute_line 'export PATH="'${ERLENV_ROOT}'/shims:${PATH}"'
}

@test "doesn't add shims to PATH more than once (fish)" {
  export PATH="${ERLENV_ROOT}/shims:$PATH"
  SHELL=/usr/bin/fish run erlenv-init -
  assert_success
  refute_line 'setenv PATH "'${ERLENV_ROOT}'/shims" $PATH ;'
}
