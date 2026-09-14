#!/usr/bin/env bash
# Print a Waybar-inspired tmux status-right value.

set -u
export LC_ALL=C

theme=${1:-colour}
if [[ $theme == monochrome ]]; then
    COLOUR_TEXT='#cccccc'
    COLOUR_CLOCK=$COLOUR_TEXT
    COLOUR_CPU=$COLOUR_TEXT
    COLOUR_MEMORY=$COLOUR_TEXT
    COLOUR_VOLUME=$COLOUR_TEXT
    COLOUR_NETWORK=$COLOUR_TEXT
else
    COLOUR_TEXT='#cccccc'
    COLOUR_CLOCK='#d9d8d8'
    COLOUR_CPU='#fa6868'
    COLOUR_MEMORY='#00fff2'
    COLOUR_VOLUME='#4bfa3c'
    COLOUR_NETWORK='#268bd2'
fi
readonly COLOUR_TEXT COLOUR_CLOCK COLOUR_CPU COLOUR_MEMORY COLOUR_VOLUME COLOUR_NETWORK

read_cpu_counters() {
    local user=0 nice=0 system=0 idle=0 iowait=0 irq=0 softirq=0 steal=0
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat || return 1
    printf '%s %s\n' \
        "$((idle + iowait))" \
        "$((user + nice + system + idle + iowait + irq + softirq + steal))"
}

cpu_usage() {
    local cache_root cache_dir cache_file old_idle='' old_total=''
    local idle total idle_delta total_delta usage

    if [[ -n ${XDG_RUNTIME_DIR:-} && -d ${XDG_RUNTIME_DIR} ]]; then
        cache_root=$XDG_RUNTIME_DIR
    else
        cache_root=${TMPDIR:-/tmp}
    fi
    cache_dir="${cache_root}/tmux-statusline-${UID:-$(id -u)}"
    cache_file="${cache_dir}/cpu"
    umask 077
    mkdir -p "$cache_dir" 2>/dev/null || true

    read -r idle total < <(read_cpu_counters) || {
        printf '0'
        return
    }

    if [[ -r $cache_file ]]; then
        read -r old_idle old_total < "$cache_file" || true
    fi

    if [[ ! $old_idle =~ ^[0-9]+$ || ! $old_total =~ ^[0-9]+$ || $total -le $old_total ]]; then
        # The first run has no prior sample, so take a short sample rather than
        # reporting the average since boot.
        old_idle=$idle
        old_total=$total
        sleep 0.1
        read -r idle total < <(read_cpu_counters) || true
    fi

    idle_delta=$((idle - old_idle))
    total_delta=$((total - old_total))
    if ((total_delta > 0)); then
        usage=$(((100 * (total_delta - idle_delta) + total_delta / 2) / total_delta))
    else
        usage=0
    fi
    ((usage < 0)) && usage=0
    ((usage > 100)) && usage=100

    if [[ -d $cache_dir ]]; then
        printf '%s %s\n' "$idle" "$total" > "${cache_file}.$$" 2>/dev/null &&
            mv -f "${cache_file}.$$" "$cache_file" 2>/dev/null || true
    fi
    printf '%s' "$usage"
}

memory_usage() {
    local key value unit
    local total=0 available=0 free=0 buffers=0 cached=0 reclaimable=0 used percentage

    while read -r key value unit; do
        case $key in
            MemTotal:)     total=$value ;;
            MemAvailable:) available=$value ;;
            MemFree:)      free=$value ;;
            Buffers:)      buffers=$value ;;
            Cached:)       cached=$value ;;
            SReclaimable:) reclaimable=$value ;;
        esac
    done < /proc/meminfo

    if ((available == 0)); then
        available=$((free + buffers + cached + reclaimable))
    fi
    if ((total > 0)); then
        used=$((total - available))
        percentage=$(((used * 100 + total / 2) / total))
        ((percentage < 0)) && percentage=0
        ((percentage > 100)) && percentage=100
        printf '%s' "$percentage"
    else
        printf '0'
    fi
}

VOLUME=''
VOLUME_MUTED=0
read_volume() {
    local output mute

    if command -v pactl >/dev/null 2>&1; then
        output=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null || true)
        VOLUME=$(grep -oE '[0-9]+%' <<< "$output" | head -n 1 | tr -d '%' || true)
        if [[ $VOLUME =~ ^[0-9]+$ ]]; then
            mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null || true)
            [[ $mute == *yes* ]] && VOLUME_MUTED=1
            return
        fi
    fi

    if command -v wpctl >/dev/null 2>&1; then
        output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || true)
        VOLUME=$(awk '/Volume:/ { printf "%.0f", $2 * 100; exit }' <<< "$output")
        if [[ $VOLUME =~ ^[0-9]+$ ]]; then
            [[ $output == *'[MUTED]'* ]] && VOLUME_MUTED=1
            return
        fi
    fi

    if command -v amixer >/dev/null 2>&1; then
        output=$(amixer get Master 2>/dev/null || true)
        VOLUME=$(grep -oE '[0-9]+%' <<< "$output" | tail -n 1 | tr -d '%' || true)
        if [[ $VOLUME =~ ^[0-9]+$ ]]; then
            [[ $output == *'[off]'* ]] && VOLUME_MUTED=1
            return
        fi
    fi

    VOLUME='--'
}

# Use current Nerd Fonts code points for fallback states. The older Waybar
# glyphs (U+F6AC/U+F796) were moved by Nerd Fonts 3.
NETWORK_ICON='󰖪'
WIFI_SIGNAL=''
read_network() {
    local wireless_path iface state quality signal path

    # /proc/net/wireless exposes the kernel link quality without starting a
    # comparatively expensive NetworkManager process every status refresh.
    for wireless_path in /sys/class/net/*/wireless; do
        [[ -d $wireless_path ]] || continue
        iface=${wireless_path%/wireless}
        iface=${iface##*/}
        if ! IFS= read -r state < "/sys/class/net/${iface}/operstate"; then
            state=''
        fi
        [[ $state == up || $state == unknown ]] || continue

        NETWORK_ICON=''
        quality=$(awk -v device="${iface}:" '
            $1 == device {
                q = $3 + 0
                p = int((q * 100 / 70) + 0.5)
                if (p < 0) p = 0
                if (p > 100) p = 100
                print p
                exit
            }
        ' /proc/net/wireless 2>/dev/null)
        if [[ $quality =~ ^[0-9]+$ ]]; then
            WIFI_SIGNAL=$quality
            return
        fi

        if command -v iw >/dev/null 2>&1; then
            signal=$(iw dev "$iface" link 2>/dev/null |
                awk '/signal:/ { p = 2 * ($2 + 100); if (p < 0) p = 0; if (p > 100) p = 100; printf "%.0f", p; exit }')
            if [[ $signal =~ ^[0-9]+$ ]]; then
                WIFI_SIGNAL=$signal
                return
            fi
        fi
        return
    done

    # Match Waybar's ethernet icon when there is an active wired interface.
    for path in /sys/class/net/*; do
        [[ -e $path ]] || continue
        iface=${path##*/}
        [[ $iface != lo && ! -d $path/wireless ]] || continue
        if ! IFS= read -r state < "$path/operstate"; then
            state=''
        fi
        [[ $state == up ]] || continue
        NETWORK_ICON='󰈀'
        return
    done
}

volume_icon() {
    if ((VOLUME_MUTED)); then
        printf '󰖁'
    elif [[ ! $VOLUME =~ ^[0-9]+$ ]] || ((VOLUME == 0)); then
        printf ''
    elif ((VOLUME < 34)); then
        printf ''
    elif ((VOLUME < 67)); then
        printf ''
    else
        printf ''
    fi
}

cpu=$(cpu_usage)
memory=$(memory_usage)
read_volume
read_network

printf '#[fg=%s]#[fg=%s] %s  ' "$COLOUR_CPU" "$COLOUR_TEXT" "$cpu"
printf '#[fg=%s]#[fg=%s] %s  ' "$COLOUR_MEMORY" "$COLOUR_TEXT" "$memory"
printf '#[fg=%s]%s' "$COLOUR_VOLUME" "$(volume_icon)"
if ((VOLUME_MUTED)); then
    printf '  '
else
    printf '#[fg=%s] %s  ' "$COLOUR_TEXT" "$VOLUME"
fi
printf '#[fg=%s]%s' "$COLOUR_NETWORK" "$NETWORK_ICON"
if [[ -n $WIFI_SIGNAL ]]; then
    printf '#[fg=%s] %s' "$COLOUR_TEXT" "$WIFI_SIGNAL"
fi
printf '#[fg=%s]  %s ' "$COLOUR_CLOCK" "$(date '+%a %d %b %H:%M')"
