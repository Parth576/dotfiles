# Defined in - @ line 1
function nmode --wraps='setxkbmap -option' --description 'alias nmode setxkbmap -option'
  setxkbmap -option $argv;
end
