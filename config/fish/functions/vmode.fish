# Defined in - @ line 1
function vmode --wraps='setxkbmap -option caps:swapescape' --description 'alias vmode setxkbmap -option caps:swapescape'
  setxkbmap -option caps:swapescape $argv;
end
