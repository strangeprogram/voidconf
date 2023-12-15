#!/bin/sh
asn2ranges() {
	local cache_file="/tmp/.bgp_tools_table_cache"
	local current_time=$(date +%s)
	local update_interval=$((2 * 60 * 60)) # 2 hours in seconds
	if [ -f "$cache_file" ]; then
		local last_update=$(date -r "$cache_file" +%s)
		local time_diff=$(($current_time - $last_update))
		if [ $time_diff -gt $update_interval ]; then
			curl -A 'acmeco bgp.tools - acid.vegas@acid.vegas' -s https://bgp.tools/table.txt -o "$cache_file"
		fi
	else
		curl -A 'acmeco bgp.tools - acid.vegas@acid.vegas' -s https://bgp.tools/table.txt -o "$cache_file"
	fi
	awk -v asn="$1" '$NF == asn {print $1}' "$cache_file"
}

asn2search() {
	local search_string="$1"
	local cache_file="/tmp/.bgp_tools_asn_cache"
	local current_time=$(date +%s)
	local update_interval=$((24 * 60 * 60)) # 24 hours in seconds
	if [ -f "$cache_file" ]; then
		local last_update=$(date -r "$cache_file" +%s)
		local time_diff=$(($current_time - $last_update))
		if [ $time_diff -gt $update_interval ]; then
			curl -A 'acmeco bgp.tools - acid.vegas@acid.vegas' -s https://bgp.tools/asns.csv -o "$cache_file"
		fi
	else
		curl -A 'acmeco bgp.tools - acid.vegas@acid.vegas' -s https://bgp.tools/asns.csv -o "$cache_file"
	fi
	grep -i "$search_string" "$cache_file"
}

bgplookup() {
	if [ -f "$1" ]; then
		{ echo "begin"; echo "verbose"; echo "count"; cat "$1"; echo "end"; } | nc bgp.tools 43
	else
		whois -h bgp.tools " -v $1"
	fi
}

cheat() {
	curl cht.sh/$1
}

clbin() {
	local url=$(cat $1 | curl -sF 'clbin=<-' https://clbin.com)
	echo "$url?<hl>"
}

color() {
	for color in {0..255}; do
		printf "\e[48;5;%sm  %3s  \e[0m" $color $color
		if [ $((($color + 1) % 6)) == 4 ]; then
			echo
		fi
	done
}

extract() {
	if [ ! -z "$1" ]; then
		if [ -f $1 ]; then
			case $1 in
				*.tar.bz2) tar xvjf $1    ;;
				*.tar.gz)  tar xvzf $1    ;;
				*.tar.xz)  tar xvJf $1    ;;
				*.lzma)    unlzma $1      ;;
				*.bz2)     bunzip2 $1     ;;
				*.rar)     unrar x -ad $1 ;;
				*.gz)      gunzip $1      ;;
				*.tar)     tar xvf $1     ;;
				*.tbz2)    tar xvjf $1    ;;
				*.tgz)     tar xvzf $1    ;;
				*.zip)     unzip $1       ;;
				*.Z)       uncompress $1  ;;
				*.7z)      7z x $1        ;;
				*.xz)      unxz $1        ;;
				*)         echo "$1 - unknown archive format" ;;
			esac
		else
			echo "$1 - file does not exist"
		fi
	fi
}

gcp() {
	git add .
	git commit -S -m "$*"
	git push
}

hf() {
	curl -F file=@$1 https://hardfiles.org/ # yeah thats right motherfucker, real bay shit, for real bay motherfuckers.
}

iso2usb() {
	sudo dd bs=4M if=$1 of=$2 status=progress
	sudo /bin/sync
}

keys() {
	echo "Ctrl + a               move to the beginning of line."
	echo "Ctrl + d               if you've type something, Ctrl + d deletes the character under the cursor, else, it escapes the current shell."
	echo "Ctrl + e               move to the end of line."
	echo "Ctrl + k               delete all text from the cursor to the end of line."
	echo "Ctrl + l               CLEAR"
	echo "Ctrl + n               DOWN"
	echo "Ctrl + p               UP"
	echo "Ctrl + q               to resume output to terminal after Ctrl + s."
	echo "Ctrl + r               begins a backward search through command history.(keep pressing Ctrl + r to move backward)"
	echo "Ctrl + s               to stop output to terminal."
	echo "Ctrl + t               transpose the character before the cursor with the one under the cursor, press Esc + t to transposes the two words before the cursor."
	echo "Ctrl + u               cut the line before the cursor; then Ctrl + y paste it"
	echo "Ctrl + w               cut the word before the cursor; then Ctrl + y paste it"
	echo "Ctrl + x + backspace   delete all text from the beginning of line to the cursor."
	echo "Ctrl + x + Ctrl + e    launch editor defined by \$EDITOR to input your command. Useful for multi-line commands."
	echo "Ctrl + z               stop current running process and keep it in background. You can use \`fg\` to continue the process in the foreground, or \`bg\` to continue the process in the background."
	echo "Ctrl + _               UNDO"
}

repo() {
	if [ ! -z "$1" ]; then
		for d in $(find $HOME/dev/git -type d -name mirrors -prune -o -type d -name .git -print); do
			r=$(basename $(dirname $d))
			if [ $1 = $r ]; then
				cd $d
			fi
		done
	fi
}

qr() {
	curl qrenco.de/$1
}

rnd() {
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1
}

title() {
	echo -ne "\033]0;$1\007"
}
