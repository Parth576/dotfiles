# Defined in - @ line 1
function tree --wraps='exa --tree ' --description 'alias tree exa --tree '
    if test (count $argv) -eq 0
        exa --tree --level=2
    else
        exa --tree --level=$argv[1]
    end
end
