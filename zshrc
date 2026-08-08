########################################
# Previous command time display        #
########################################
_cmd_timer_start=0
_cmd_time_display=""

PROMPT='${_cmd_time_display}'"$PROMPT"

_cmd_timer_preexec() {
	_cmd_timer_start=$EPOCHREALTIME
}

_cmd_timer_precmd() {
	if (( _cmd_timer_start > 0 )); then
		local elapsed=$(( EPOCHREALTIME - _cmd_timer_start ))
		local -i ms=$(( elapsed * 1000 ))
		local iii=$(( ms % 1000 ))
		local totalSecs=$(( ms / 1000 ))
		local ss=$(( totalSecs % 60 ))
		local mm=$(( (totalSecs / 60) % 60 ))
		local hh=$(( totalSecs / 3600 ))
		_cmd_time_display="%F{240}$(printf '%02d:%02d:%02d.%03d' $hh $mm $ss $iii)%f "
	else
		_cmd_time_display=""
	fi
	_cmd_timer_start=0
}

preexec_functions+=(_cmd_timer_preexec)
precmd_functions+=(_cmd_timer_precmd)
