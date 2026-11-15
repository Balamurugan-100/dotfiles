# ~/.zshenv — Read before /etc/zsh/zshrc and ~/.zshrc for all zsh shells

# Skip Ubuntu's slow global compinit in /etc/zsh/zshrc (reduces startup time by ~500ms)
skip_global_compinit=1

# Ensure local bin is on PATH early
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
