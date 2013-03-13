ERLENV_TEST_DIR="${BATS_TMPDIR}/erlenv"
export ERLENV_ROOT="${ERLENV_TEST_DIR}/root"
export HOME="${ERLENV_TEST_DIR}/home"

unset ERLENV_VERSION
unset ERLENV_DIR

export PATH="${ERLENV_TEST_DIR}/bin:$PATH"
export PATH="${BATS_TEST_DIRNAME}/../libexec:$PATH"
export PATH="${BATS_TEST_DIRNAME}/libexec:$PATH"
export PATH="${ERLENV_ROOT}/shims:$PATH"

teardown() {
  rm -rf "$ERLENV_TEST_DIR"
}

flunk() {
  echo "$@" | sed "s:${ERLENV_ROOT}:\$ERLENV_ROOT:" >&2
  return 1
}

assert_success() {
  if [ "$status" -ne 0 ]; then
    flunk "command failed with exit status $status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_failure() {
  if [ "$status" -eq 0 ]; then
    flunk "expected failed exit status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_output() {
  if [ "$output" != "$1" ]; then
    flunk "expected: $1"      || true
    flunk "got:      $output"
  fi
}

assert_line() {
  for line in "${lines[@]}"; do
    if [ "$line" = "$1" ]; then return 0; fi
  done
  flunk "expected line \`$1'"
}

refute_line() {
  for line in "${lines[@]}"; do
    if [ "$line" = "$1" ]; then flunk "expected to not find line \`$line'"; fi
  done
}

assert() {
  if ! "$@"; then
    flunk "failed: $@"
  fi
}
