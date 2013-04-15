#!/usr/bin/env bats

load test_helper

@test "without args shows summary of common commands" {
  run erlenv-help
  assert_success
  assert_line "Usage: erlenv <command> [<args>]"
  assert_line "Some useful erlenv commands are:"
}

@test "invalid command" {
  run erlenv-help hello
  assert_failure "erlenv: no such command \`hello'"
}

@test "shows help for a specific command" {
  mkdir -p "${ERLENV_TEST_DIR}/bin"
  cat > "${ERLENV_TEST_DIR}/bin/erlenv-hello" <<SH
#!shebang
# Usage: erlenv hello <world>
# Summary: Says "hello" to you, from erlenv
# This command is useful for saying hello.
echo hello
SH

  run erlenv-help hello
  assert_success
  assert_output <<SH
Usage: erlenv hello <world>

This command is useful for saying hello.
SH
}

@test "replaces missing extended help with summary text" {
  mkdir -p "${ERLENV_TEST_DIR}/bin"
  cat > "${ERLENV_TEST_DIR}/bin/erlenv-hello" <<SH
#!shebang
# Usage: erlenv hello <world>
# Summary: Says "hello" to you, from erlenv
echo hello
SH

  run erlenv-help hello
  assert_success
  assert_output <<SH
Usage: erlenv hello <world>

Says "hello" to you, from erlenv
SH
}

@test "extracts only usage" {
  mkdir -p "${ERLENV_TEST_DIR}/bin"
  cat > "${ERLENV_TEST_DIR}/bin/erlenv-hello" <<SH
#!shebang
# Usage: erlenv hello <world>
# Summary: Says "hello" to you, from erlenv
# This extended help won't be shown.
echo hello
SH

  run erlenv-help --usage hello
  assert_success "Usage: erlenv hello <world>"
}

@test "multiline usage section" {
  mkdir -p "${ERLENV_TEST_DIR}/bin"
  cat > "${ERLENV_TEST_DIR}/bin/erlenv-hello" <<SH
#!shebang
# Usage: erlenv hello <world>
#        erlenv hi [everybody]
#        erlenv hola --translate
# Summary: Says "hello" to you, from erlenv
# Help text.
echo hello
SH

  run erlenv-help hello
  assert_success
  assert_output <<SH
Usage: erlenv hello <world>
       erlenv hi [everybody]
       erlenv hola --translate

Help text.
SH
}

@test "multiline extended help section" {
  mkdir -p "${ERLENV_TEST_DIR}/bin"
  cat > "${ERLENV_TEST_DIR}/bin/erlenv-hello" <<SH
#!shebang
# Usage: erlenv hello <world>
# Summary: Says "hello" to you, from erlenv
# This is extended help text.
# It can contain multiple lines.
#
# And paragraphs.

echo hello
SH

  run erlenv-help hello
  assert_success
  assert_output <<SH
Usage: erlenv hello <world>

This is extended help text.
It can contain multiple lines.

And paragraphs.
SH
}
