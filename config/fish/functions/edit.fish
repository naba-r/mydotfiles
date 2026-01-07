function edit
    if test (count $argv) -eq 0
        msedit
        return
    end
    
    set owner (stat -c %U $argv[1])
    
    if test "$owner" = (whoami)
        msedit $argv
    else
        sudo -E msedit $argv
    end
end
