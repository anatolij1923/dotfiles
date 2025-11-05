function sleep_timer
    if test -z "$argv[1]"
        echo "Usage: sleep_timer <time>"
        echo "Example: sleep_timer 1h"
        return 1
    end
    echo "Pausing media and suspend in $argv[1]..."
   sleep $argv[1] && playerctl -a pause 
   systemctl suspend -f
end
