if type -q batcat
    alias cat batcat
else if type -q bat
    alias cat bat
end

set -gx PATH "$HOME/.dotnet" $PATH
set -gx PATH "$HOME/.local/bin" $PATH

set -Ux ORG_DIRECTORY ~/Dropbox/org
set -Ux ORG_ROAM_DIRECTORY ~/Dropbox/org-roam
set -Ux SSH_AUTH_SOCK ~/.1password/agent.sock
set -x OP_BIOMETRIC_UNLOCK_ENABLED true
# Universal exported var so every fish session has it
set -Ux LIBVIRT_DEFAULT_URI qemu:///system
# (to remove later: set -eU LIBVIRT_DEFAULT_URI)
#
# 
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
set -gx PATH "$HOME/.config/composer/vendor/bin" $PATH
set -gx ZK_NOTEBOOK_DIR /home/rik/Dropbox/notes
set -gx STOW_DIR /home/rik/.dotfiles

#oh-my-posh init fish --config M365Princess | source
#
starship init fish | source
