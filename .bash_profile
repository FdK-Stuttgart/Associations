# This file must be pressent otherwise the guix shell doesn't start, however the
# The `echo` and `printf` commands do not output anything on the CLI. WTF?

# echo "echo \"### .bash_profile\""
# printf "printf \"### .bash_profile\""

# Setups system and user profiles and related variables
# /etc/profile will be sourced by bash automatically
# Setups home environment profile
if [ -f ~/.profile ]; then source ~/.profile; fi

# Honor per-interactive-shell startup file
if [ -f ~/.bashrc ]; then source ~/.bashrc; fi
export HISTFILE=$XDG_CACHE_HOME/.bash_history
