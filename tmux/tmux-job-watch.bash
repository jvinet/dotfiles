# Source from an interactive Bash shell inside tmux. Requires Bash 4.4+ (PS0).
# No DEBUG trap, process polling, terminal bells, or changes to PS1.

[[ $- == *i* && -n ${TMUX:-} && -n ${TMUX_PANE:-} ]] || return 0
((BASH_VERSINFO[0] > 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 4))) || return 0
[[ ${_tmux_job_watch_installed_pid:-} != "$$" ]] || return 0

_tmux_job_watch_script="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/tmux-job-watch.sh"
[[ -r $_tmux_job_watch_script ]] || return 0

_tmux_job_watch_start() {
    local status=$?
    bash "$_tmux_job_watch_script" start "$TMUX_PANE" "$$" >/dev/null 2>&1 || :
    return "$status"
}

_tmux_job_watch_prompt() {
    local status=$?
    bash "$_tmux_job_watch_script" complete "$TMUX_PANE" "$$" >/dev/null 2>&1 || :
    # Existing prompt hooks and commands such as `echo $?` see the real status.
    return "$status"
}

# Bash expands PS0 only after reading a command, not for initial/empty prompts.
# Its command substitution produces no output and leaves existing PS0 intact.
PS0=${PS0-}'$(_tmux_job_watch_start)'
if [[ $(declare -p PROMPT_COMMAND 2>/dev/null) == 'declare -a'* ]]; then
    PROMPT_COMMAND=(_tmux_job_watch_prompt "${PROMPT_COMMAND[@]}")
else
    PROMPT_COMMAND="_tmux_job_watch_prompt${PROMPT_COMMAND:+$'\n'$PROMPT_COMMAND}"
fi
_tmux_job_watch_installed_pid=$$
