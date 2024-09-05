#!/bin/bash
#echo `uptime`
uptime=$(</proc/uptime)
uptime=${uptime%%.*}

seconds=$(( uptime%60 ))
minutes=$(( uptime/60%60 ))
hours=$(( uptime/60/60%24 ))
days=$(( uptime/60/60/24 ))

echo System Uptime - "$days day(s) $hours hour(s) $minutes minute(s)"
