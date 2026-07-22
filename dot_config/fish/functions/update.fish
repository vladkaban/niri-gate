function update --wraps='sudo pacman -Syu && paru -Sua' --description 'alias update sudo pacman -Syu && paru -Sua'
    sudo pacman -Syu && paru -Sua $argv
end
