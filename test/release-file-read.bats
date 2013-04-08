#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "${ERLENV_TEST_DIR}/myproject"
  cd "${ERLENV_TEST_DIR}/myproject"
}

@test "fails without arguments" {
  run erlenv-release-file-read
  assert_failure ""
}

@test "fails for invalid file" {
  run erlenv-release-file-read "non-existent"
  assert_failure ""
}

@test "reads simple release file" {
  cat > my-version <<<"r16c"
  run erlenv-release-file-read my-version
  assert_success "r16c"
}

@test "reads only the first word from file" {
  cat > my-version <<<"r16c r16d hi"
  run erlenv-release-file-read my-version
  assert_success "r16c"
}

@test "loads only the first line in file" {
  cat > my-version <<IN
1.8.7 one
1.9.3 two
IN
  run erlenv-release-file-read my-version
  assert_success "1.8.7"
}
