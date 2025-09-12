# ~/.bashrc.d/ssh-agent.sh

start_ssh_agent() {
    SSH_ENV="$HOME/.ssh/ssh-agent-environment"

    start_new_agent() {
        ssh-agent | head -2 > "$SSH_ENV"
        chmod 600 "$SSH_ENV"
        . "$SSH_ENV" >/dev/null
        _ssh_add_keys
        echo "SSH agent started."
    }

    _ssh_add_keys() {
        shopt -s nullglob
        # Collect IdentityFile entries from ~/.ssh/config
        mapfile -t cfg_keys < <(
            awk '/^[[:space:]]*IdentityFile[[:space:]]+/ {print $2}' "$HOME/.ssh/config" 2>/dev/null \
            | sed -e 's#"##g' -e "s#^~#$HOME#"
        )
        if [[ ${#cfg_keys[@]} -eq 0 ]]; then
            # Fallback: add all private keys in ~/.ssh
            cfg_keys=( "$HOME"/.ssh/id_* )
        fi
        for k in "${cfg_keys[@]}"; do
            [[ -f $k ]] && ssh-keygen -y -f "$k" >/dev/null 2>&1 && ssh-add "$k" >/dev/null 2>&1
        done
    }

    if [[ -f "$SSH_ENV" ]]; then
        . "$SSH_ENV" >/dev/null
        if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
            start_new_agent
        elif ! ssh-add -l >/dev/null 2>&1; then
            _ssh_add_keys
        fi
    else
        start_new_agent
    fi
}

# Only run in interactive shells
case $- in
  *i*) start_ssh_agent ;;
esac

