# space at the end accepts aliases for following command
alias s='sudo ' sudo='sudo '

### clipboard selection ###
alias xsel='xsel -n -l /dev/null'
alias xcl='xsel --clipboard' xsl='xsel --primary'
#alias xcl='xclip -selection clipboard' xsl='xclip -selection primary'
#yank
#alias ycl='xclip --srlection clipboard -i' ysl='xclip --selection primary -i'
alias ycl='xcl -i <' ysl='xsl -i <'
#paste
alias pcl='xcl -o' psl='xsl -o'

alias c='cd' c-='cd -' cg='c `git rev-parse --show-toplevel 2> /dev/null`'

#normal, dir, exe, secure, secure dir
alias cm='chmod' cmn='cm 644' cmd='cm 755' cmx='cm 744' cms='cm 600' cmsd='cm 700'

alias f='find'
alias grep='prep --color=auto'
alias h='man'
alias ls='ls -F --color=auto --group-directories-first' l='ls' ll='ls -l -h' la='ls -A' lal='ll -A'
alias m='mv'
alias mkdir='mkdir -p' md='mkdir' mf='touch'
alias p='cp'
alias py='python'
alias q='exit'
alias rmd='rmdir'
alias rnm='rename'
alias sa='ssh-add'
alias sysc='systemctl'
alias sln='ln -s'
#alias t='urxvtc'
alias t='mlterm'
#Gzip
alias targ='tar zvcf' untar='tar xvf'
#Diff External
alias v='nvim' vi='v -u NONE' vd='v -d' ve='urxvtc -e nvim'

#git
alias g='git'
alias ga='g add'
alias gc='g commit' gca='gc --amend'
alias gco='g checkout'
alias gcl='pcl | xargs git clone'
alias gd='g diff'
alias gm='g mv'
alias gra='pcl | xargs git remote add' grau='pcl | xargs git remote add upstream'
alias grb='g rebase -i'
alias grm='g rm'
alias grs='g reset' grsh='grs --hard'
alias grv='g revert'
alias gs='g status'
alias gh='hub' ghb='gh browse'

gb() {
	if test "$#" -gt 0
	then
		command git checkout -b $@
		return
	fi

	command git branch
}

#arch linux
#alias pd='pacdiff'
#alias pm='pacman' pmi='pm -S' pms='pm -Ss' pmr='pm -Rsn' pmu='pm -Syu' pmq='pm -Qe'
#alias pma='aura' pmai='pma -A' pmas='pma -Aas' pmar='pma -Rsn' pmau='pma -Ayu' pmau='pm -Qem' pmad='pma -Aw'
