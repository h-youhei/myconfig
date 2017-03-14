# accept aliases for sudo
alias s='sudo ' sudo='sudo '

alias c='cd' c-='cd -' cg='c `git rev-parse --show-toplevel 2> /dev/null`'
alias cm='chmod' cmx='chmod 755'
alias f='find'
alias g='git' ga='g add' gc='g commit' gca='gc --amend' gco='g checkout' gcl='xclip -o | xargs git clone' gm='g mv' grau='xclip -o | xargs git remote add upstream' grb='g rebase -i' grm='g rm' grs='g reset' gs='g status'
alias gh='hub' ghb='gh browse'
alias h='man'
alias ls='ls -F --group-directories-first' lsl='ls -l -h' l='ls -A' ll='lsl -A'
alias m='mv'
alias mkdir='mkdir -p' md='mkdir'
alias p='cp'
alias pd='pacdiff'
alias pm='pacman' pmi='pm -S' pms='pm -Ss' pmr='pm -Rsn' pmu='pm -Syu' pmq='pm -Qe'
alias pma='aura' pmai='pma -A' pmas='pma -Aas' pmar='pma -Rsn' pmau='pma -Ayu' pmau='pm -Qem' pmad='pma -Aw'
alias py='python'
alias q='exit'
alias rmd='rmdir'
alias rnm='rename'
alias sa='ssh-add'
alias sln='ln -s'
alias t='urxvtc'
#Gzip
alias targ='tar zvcf' untar='tar xvf'
#Readonly External
alias v='nvim' vr='v -s -R -' vi='v -u NONE' cv='cvim' ve='urxvtc -e nvim'
# save dir for xmonad
alias x="pwd > $HOME/.xmonad/mark"
alias xclip='xclip -selection clipboard' xp='xclip -o'

alias -g A='| awk'
alias -g C='| cut'
alias -g F='| fzf'
alias -g G='| grep'
alias -g H='| head'
alias -g J='| join'
alias -g L='| less'
alias -g O='| sort'
alias -g P='| paste'
alias -g R='| tr'
alias -g S='| sed'
alias -g T='| tail'
alias -g U='| uniq'
alias -g V='| tac'
alias -g W='| wc'
alias -g X='| xargs'
alias -g X@='| xargs -I @@'
alias -g Y='| xclip'

gb() {
	if test "$#" -gt 0
	then
		command git checkout -b $@
		return
	fi

	command git branch
}
