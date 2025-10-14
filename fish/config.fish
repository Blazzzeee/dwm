# Initialization code that may require console input (password prompts, [y/n] confirmations, etc.)
# Everything else should go below this block.

# Set PATH
set -gx PATH $HOME/.local/bin $PATH

# fzf setup for directories (ncd and hx)
function ncd
    # Find directories, pass them through fzf, and store the result
    set dir (find $HOME \( -type d \! -name '.*' -o -name '.config' -o -name '.cache' \) | fzf --height 25% --layout reverse --border)
    # Check if a directory was selected
    if test -n "$dir"
        cd $dir # Navigate to the directory using zoxide
    end
end

function run_ncd
    ncd
    nvim .
end

# Register the widget
bind \ed run_ncd # Bind Alt+d to open nvim dir with fzf

# # View file trees using fzf and eza
# function fd
#     set dir (find $argv[1] -type d 2>/dev/null | fzf --height 50% --layout reverse --border --preview 'eza --tree --color=always --icons {}' --preview-window=right:60%)
#     if test -n "$dir"
#         cd $dir
#     end
# end

# # Bind Alt+d to view dir tree using fzf
# bind \ed fd

oh-my-posh init fish --config ~/.config/ohmyposh/base.toml | source

# Initialize zoxide (path may vary for fish)
zoxide init fish | source

# Use eza instead of ls with color
alias ls="eza --color=always --icons=always"

# Plugin: zoxide (for replacing cd)
function zoxide_init
    eval (zoxide init fish)
end

# Custom alias
alias hyprcfg="hx ~/.config/hypr/hyprland.conf"

# Plugins
# You can add custom Fish plugins, e.g., fzf, zoxide, etc.

# Enable auto-suggestions (Fish equivalent to Zsh's autosuggestions)
fish_add_path $HOME/.config/fish/functions

# To enable instant prompt, use p10k for Fish (if available)
if test -f ~/.p10k.fish
    source ~/.p10k.fish
end

# Set editor
# If remote, set the editor to nvim
if test -n "$SSH_CONNECTION"
    set -gx EDITOR nvim
else
    set -gx EDITOR vim
end

# status --is-interactive; and direnv hook fish | source
eval (direnv hook fish)

# Set locale
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8

# Android SDK
set -x ANDROID_HOME ~/Android/Sdk
set -x PATH $ANDROID_HOME/cmdline-tools/latest/bin $ANDROID_HOME/platform-tools $PATH
set -x GEMINI_API_KEY AIzaSyCZv-QkfMJnuJN9JfkgUQzitXKrv7R2c9A

# Yazi alias `y` in Fish, move to directory used by Yazi
function y
    # Create a temporary file
    set tmp (mktemp -t yazi-cwd.XXXXXX)
    set cwd

    # Launch yazi with the temp file to track cwd
    yazi $argv --cwd-file=$tmp

    # Read the directory from the temp file
    if test -f $tmp
        set cwd (cat $tmp)
        if test -n "$cwd" -a "$cwd" != (pwd)
            cd $cwd
        end
        rm -f $tmp
    end
end

# Optional: bind Alt+y to run yazi
bind \ey y

alias nv="nvim ."
alias vim="nvim"
