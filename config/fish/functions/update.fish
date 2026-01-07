function update --wraps='sudo zypper refresh; sudo zypper dup; date +%s > ~/.lastdup' --description 'alias update=sudo zypper refresh; sudo zypper dup; date +%s > ~/.lastdup'
  sudo zypper refresh; sudo zypper dup; date +%s > ~/.lastdup $argv
        
end
