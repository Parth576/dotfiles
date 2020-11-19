# Defined in - @ line 1
function ls --wraps='exa --long --group-directories-first' --description 'alias ls exa --long --group-directories-first'
  exa --long --group-directories-first $argv;
end
