if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end
if test -n "$WAYLAND_DISPLAY"
    set -gx CLIPBOARD_PROVIDER wl-clipboard
end
if test -f ~/.cache/wallust/sequences
    cat ~/.cache/wallust/sequences
end
set -g fish_greeting
if status is-interactive
    cal -m > /tmp/cal_raw.txt

    set -l raw_ansi (set_color --print-colors | grep -i "^$fish_color_command" | awk '{print $2}')
    if test -z "$raw_ansi"; or test "$fish_color_command" = "purple"
        set raw_ansi "\x1b[35m"
    else if test "$fish_color_command" = "cyan"
        set raw_ansi "\x1b[36m"
    else if test "$fish_color_command" = "blue"
        set raw_ansi "\x1b[34m"
    else if test "$fish_color_command" = "green"
        set raw_ansi "\x1b[32m"
    else if test "$fish_color_command" = "red"
        set raw_ansi "\x1b[31m"
    else if test "$fish_color_command" = "yellow"
        set raw_ansi "\x1b[33m"
    else
        set raw_ansi "\x1b[35m"
    end

    awk -v today=(date +%e | tr -d ' ') -v c_color="$raw_ansi" '
    BEGIN {
        pig[1] = "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣤⣶⣶⣶⣶⣦⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        pig[2] = "⠀⠀⢀⡶⢻⡦⢀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣴⣾⡿⠀⣠⠀⠀"
        pig[3] = "⠀⠠⣬⣷⣾⣡⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣌⣋⣉⣄⠘⠋⠀⠀"
        pig[4] = "⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⡄⠀⠀⠀"
        pig[5] = "⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⣿⣷⣶⡄⠀"
        pig[6] = "⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀"
        pig[7] = "⠀⠀⠀⠀⠸⣿⣿⣿⠛⠛⠛⠛⠛⠛⠛⠛⠻⠿⣿⣿⡿⠛⠛⠛⠋⠉⠉⠀⠀⠀"
        pig[8] = "⠀⠀⠀⠀⠀⢻⣿⣿⠀⠀⢸⣿⡇⠀⠀⠀⠀⠀⢻⣿⠃⠸⣿⡇⠀⠀⠀⠀⠀⠀"
        pig[9] = "⠀⠀⠀⠀⠀⠈⠿⠇⠀⠀⠀⠻⠇⠀⠀⠀⠀⠀⠈⠿⠀⠀⠻⠿⠀⠀⠀⠀⠀⠀"
        pig_count = 9
        normal_day = "\x1b[2;37m"
    }
    {
        raw_cal[FNR] = $0
        if (FNR == 1) {
            out_line = c_color "\x1b[1m" $0 "\x1b[0m"
        } else if (FNR == 2) {
            out_line = "\x1b[37m" substr($0, 1, 14) c_color substr($0, 15) "\x1b[0m"
        } else {
            has_today = 0
            for (i = 0; i < 7; i++) {
                cell = substr($0, i*3 + 1, 3)
                val = cell
                gsub(/^[ \t]+|[ \t]+$/, "", val)
                if (val == today) has_today = 1
            }
            out_line = ""
            for (i = 0; i < 7; i++) {
                cell = substr($0, i*3 + 1, 3)
                val = cell
                gsub(/^[ \t]+|[ \t]+$/, "", val)
                if (val == "") {
                    out_line = out_line cell
                } else {
                    if (val == today) {
                        if (length(val) == 1) {
                            out_line = out_line " \x1b[7m" val "\x1b[0m "
                        } else {
                            out_line = out_line "\x1b[7m" val "\x1b[0m "
                        }
                    } else {
                        style = (has_today || i >= 5) ? c_color : normal_day
                        out_line = out_line style cell "\x1b[0m"
                    }
                }
            }
        }
        cal[FNR] = out_line
        cal_count = FNR
    }
    END {
        max = pig_count
        if ((cal_count + 1) > max) max = cal_count + 1
        for (i = 1; i <= max; i++) {
            # 1. Свинья
            if (i <= pig_count) {
                printf "%s", c_color pig[i] "\x1b[0m"
            } else {
                printf "                                          "
            }
            printf " "
            
            # 2. Блок цветов wallust
            if (i >= 2 && i <= 9) {
                c_idx = i - 2
                printf " \x1b[48;5;%dm  \x1b[48;5;%dm  \x1b[0m ", c_idx, c_idx + 8
            } else {
                printf "       "
            }
            printf "   "
            
            # 3. Календарь
            if (i >= 2 && (i - 1) <= cal_count) {
                printf "%s", cal[i - 1]
            }
            printf "\n"
        }
    }' /tmp/cal_raw.txt
    rm -f /tmp/cal_raw.txt
end

cat ~/.cache/wallust/sequences

alias update 'sudo pacman -Syu && paru -Sua'
alias pisun 'kitty +kitten icat /home/vlad/hdd/rofls/serega.jpg'
alias trava 'kitty +kitten icat /home/vlad/hdd/rofls/weed.jpg'
alias rec="/home/vlad/.config/niri/record.sh"

alias cmp="git -C \$HOME/.local/share/chezmoi add -A && git -C \$HOME/.local/share/chezmoi commit -m 'update' && git -C \$HOME/.local/share/chezmoi push origin main"
alias cme="chezmoi edit"
alias cma="chezmoi add"
alias cmf="chezmoi forget"
alias cha="chezmoi apply"

set -g fish_color_normal normal
set -g fish_color_command magenta --bold
set -g fish_color_param brwhite
set -g fish_color_keyword magenta --bold
set -g fish_color_quote brwhite
set -g fish_color_error bryellow --bold

function fish_prompt
    echo -ne "\x1b[1;35mfish > \x1b[0m"
end

# function chezmoi-cd
#     cd (chezmoi source-path)
# end

export MICRO_TRUECOLOR=1

set -gx GITHUB_TOKEN " SHA256:JaZ5xpAQ5CWuKH6n3+smTBkOjt4QCRdUFWzfAkmomJ0 "
