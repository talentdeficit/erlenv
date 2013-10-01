function __fish_erlenv_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 -a $cmd[1] = 'erlenv' ]
    return 0
  end
  return 1
end

function __fish_erlenv_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

complete -f -c erlenv -n '__fish_erlenv_needs_command' -a '(erlenv commands)'
for cmd in (erlenv commands)
  complete -f -c erlenv -n "__fish_erlenv_using_command $cmd" -a "(erlenv completions $cmd)"
end
