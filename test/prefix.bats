#!/usr/bin/env bats

load test_helper

@test "prefix" {
  mkdir -p "${ERLENV_TEST_DIR}/myproject"
  cd "${ERLENV_TEST_DIR}/myproject"
  echo "1.2.3" > .erlang-release
  mkdir -p "${ERLENV_ROOT}/releases/1.2.3"
  run erlenv-prefix
  assert_success "${ERLENV_ROOT}/releases/1.2.3"
}

@test "prefix for invalid release" {
  ERLENV_RELEASE="1.2.3" run erlenv-prefix
  assert_failure "erlenv: release \`1.2.3' not installed"
}

@test "prefix for system" {
  mkdir -p "${ERLENV_TEST_DIR}/bin"
  touch "${ERLENV_TEST_DIR}/bin/erl"
  chmod +x "${ERLENV_TEST_DIR}/bin/erl"
  ERLENV_RELEASE="system" run erlenv-prefix
  assert_success "$ERLENV_TEST_DIR"
}

@test "prefix for invalid system" {
  USRBIN_ALT="${ERLENV_TEST_DIR}/usr-bin-alt"
  mkdir -p "$USRBIN_ALT"
  for util in head readlink greadlink; do
    if [ -x "/usr/bin/$util" ]; then
      ln -s "/usr/bin/$util" "${USRBIN_ALT}/$util"
    fi
  done
  PATH_WITHOUT_ERLANG="${PATH/\/usr\/bin:/$USRBIN_ALT:}"

  PATH="$PATH_WITHOUT_ERLANG" run erlenv-prefix system
  assert_failure "erlenv: system version not found in PATH"
}
