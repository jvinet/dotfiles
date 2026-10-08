#!/usr/bin/env bash
# Event handler for tmux-job-watch.bash and the prefix-! binding.

set -u

case ${1:-} in
    toggle)
        window=${2:-}
        [[ $window =~ ^@[0-9]+$ ]] || exit 2
        tmux if-shell -F -t "$window" '#{@watch-jobs}' \
            "set-option -w -t $window @watch-jobs 0; set-option -w -t $window @job-done 0; display-message 'Job watching off'" \
            "set-option -w -t $window @watch-jobs 1; set-option -w -t $window @job-done 0; display-message 'Job watching on'"
        ;;
    start|complete)
        pane=${2:-}
        shell_pid=${3:-}
        [[ $pane =~ ^%[0-9]+$ && $shell_pid =~ ^[0-9]+$ ]] || exit 2
        # PS0 runs in a subshell; $$ still identifies the interactive shell.
        # Separate markers also keep nested Bash shells from consuming theirs
        # or their parent's pending command.
        pending="@job-watch-running-$shell_pid"
        if [[ $1 == start ]]; then
            # Record even when watching is off, so it can be enabled mid-job.
            tmux set-option -p -t "$pane" "$pending" 1
        else
            # Resolve the window from the pane at completion time. A window
            # selected in ANY session is considered active (even if detached).
            tmux if-shell -F -t "$pane" \
                "#{&&:#{$pending},#{&&:#{@watch-jobs},#{==:#{window_active_sessions},0}}}" \
                "set-option -w -t $pane @job-done 1" \
                \; set-option -pu -t "$pane" "$pending"
        fi
        ;;
    *)
        printf 'Usage: %s toggle @window | start|complete %%pane shell-pid\n' "$0" >&2
        exit 2
        ;;
esac
