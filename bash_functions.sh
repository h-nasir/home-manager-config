echof() {
    local bold=false
    local underline=false
    local inverse=false
    local color_code=0
    local text=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --bold) bold=true ;;
            --underline) underline=true ;;
            --inverse) inverse=true ;;
            --black) color_code=30 ;;
            --red) color_code=31 ;;
            --green) color_code=32 ;;
            --yellow) color_code=33 ;;
            --blue) color_code=34 ;;
            --magenta) color_code=35 ;;
            --cyan) color_code=36 ;;
            --white) color_code=37 ;;
            *) text="$*"; break ;;
        esac
        shift
    done

    local style=""
    $bold && style="${style}1;"
    $underline && style="${style}4;"
    $inverse && style="${style}7;"
    style="${style}${color_code}"

    echo -e "\e[${style}m${text}\e[0m"
}

wrun() {
    set +m

    if [ $# -lt 2 ]; then
        echo "Usage: wrun <command> <file> [file2 ...]"
        return 1
    fi

    local cmd="$1"
    shift
    local watchFiles=("$@")

    for f in "${watchFiles[@]}"; do
        [ -e "$f" ] || { echo "File '$f' does not exist"; return 1; }
    done

    local pid=""

    inotifywait -e close_write,moved_to,create -m . |
    while read -r dir events file; do
        local match=false
        for watchFile in "${watchFiles[@]}"; do
            [ "$file" = "$watchFile" ] && match=true && break
        done
        $match || continue

        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            continue
        fi

        echof --yellow --bold "[$(date '+%H:%M:%S')] Detected change in $file → Running: $cmd"

        eval "$cmd" &
        pid=$!
    done
}
