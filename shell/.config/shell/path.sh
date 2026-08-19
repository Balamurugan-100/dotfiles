# ~/.config/shell/path.sh
# Centralized PATH setup for macOS

# Start with system defaults
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Homebrew (Apple Silicon)
if [ -d "/opt/homebrew/bin" ]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

# Homebrew (Intel)
if [ -d "/usr/local/bin" ]; then
  export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
fi

# User bins
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

