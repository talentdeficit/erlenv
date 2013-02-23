if [[ ! -o interactive ]]; then
return
fi

compctl -K _erlenv erlenv

_erlenv() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
completions="$(erlenv commands)"
  else
completions="$(erlenv completions ${words[2,-2]})"
  fi

reply=("${(ps:\n:)completions}")
}