function sleep_timer
    set -l input "$argv"

    if test -z "$input"
        echo "Usage: sleep_timer <time> (e.g., 1h 30m)"
        return 1
    end

    if not string match -rq '^(\d+[smh]\s*)+$' "$input"
        set_color red
        echo "Error: Invalid format '$input'"
        set_color normal
        return 1
    end

    set -l total_seconds 0
    for part in (string match -ra '\d+[smh]' "$input")
        set -l val (string match -r '\d+' $part)
        set -l unit (string match -r '[smh]' $part)
        switch $unit
            case s
                set total_seconds (math $total_seconds + $val)
            case m
                set total_seconds (math $total_seconds + $val \* 60)
            case h
                set total_seconds (math $total_seconds + $val \* 3600)
        end
    end

    set -l start_time (date +%s)
    set -l end_time (math $start_time + $total_seconds)

    tput civis
    trap "tput cnorm; echo; return 1" INT SIGINT SIGTERM

    echo "Sleep in: $input"

    while true
        set -l current_time (date +%s)
        set -l remaining (math $end_time - $current_time)
        if test $remaining -le 0
            break
        end

        set -l percent (math -s0 "(($total_seconds - $remaining) * 100) / $total_seconds")
        set -l width 40
        set -l filled (math -s0 "($percent * $width) / 100")
        set -l empty (math $width - $filled)

        set -l h (math -s0 $remaining / 3600)
        set -l m (math -s0 "(" $remaining % 3600 ")" / 60)
        set -l s (math -s0 $remaining % 60)
        set -l time_str (printf "%02d:%02d:%02d" $h $m $s)

        printf "\r"
        tput el
        set_color yellow
        printf "["
        set_color cyan
        printf "%s" (string repeat -n $filled "█")
        set_color 444
        printf "%s" (string repeat -n $empty "█")
        set_color yellow
        printf "] %s (%d%%)" $time_str $percent
        set_color normal

        sleep 1
    end

    tput cnorm
    echo -e "\n\nPausing media and suspending..."
    playerctl -a pause 2>/dev/null
    loginctl lock-session
    systemctl suspend
end
