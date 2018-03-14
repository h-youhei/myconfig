# space at the end accepts aliases for following command
alias s='sudo ' sudo='sudo '
alias se='sudoedit'

### clipboard selection ###
alias xsel='xsel -l /dev/null'
alias xcl='xsel --clipboard' xsl='xsel --primary'
#alias xcl='xclip -selection clipboard' xsl='xclip -selection primary'
#yank
#alias ycl='xclip --selection clipboard -i' ysl='xclip --selection primary -i'
alias ycl='xcl -i <' ysl='xsl -i <'
#paste
alias pcl='xcl -o' psl='xsl -o'

alias c='cd' pd='cd -' cg='c `git rev-parse --show-toplevel 2> /dev/null`'

#Normal, Dir, eXe, Secure, SecureDir
alias cm='chmod' cmn='cm 644' cmd='cm 755' cmx='cm 744' cms='cm 600' cmsd='cm 700'

alias df='df -h'
#Edit, EditDirectory
alias e='kak-git' ed='vidir'
alias f='fd'
alias grep='grep -E -R --color=auto'
#Help
alias h='man'
alias ls='ls -F --color=auto --group-directories-first' l='ls' ll='ls -l -h' la='ls -A' lal='ll -A'
alias m='mv'
alias mkdir='mkdir -p' md='mkdir'
#MakeFile
alias mf='touch'
mdc() {
	mkdir -p "$@" && cd "$_"
}
alias p='cp'
alias py='python'
alias q='exit'
alias rmd='rmdir'
alias rnm='rename'
alias sa='ssh-add'
alias sysc='systemctl'
alias sln='ln -s'
alias t='mlterm'
#Bzip Gzip Xz
alias tarb='tar cvf --bzip2' targ='tar cvf --gzip' tarx='tar cvf --xz' untar='tar xvf'
alias v='vim' vi='v -u NONE'

### git ###
alias g='git'
alias ga='g add'
alias gc='g commit' gca='gc --amend'
alias gg='g grep'
alias gco='g checkout'
alias gcl='pcl | xargs git clone'
alias gd='g diff'
alias gl='g log --graph'
alias gm='g mv'
alias gra='pcl | xargs git remote add' grau='pcl | xargs git remote add upstream'
alias grb='g rebase -i' grbc='g rebase --continue'
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

### package manager ###
## gentoo linux ##
#Config, Delete, fetch
alias pm='emerge' pmc='dispatch-conf' pmd='pm --deselect' pmD='pm -a --depclean' pmf='pm -f'
#Install, Log, Oneshot, sYnc, Update
alias pmi='pm -av' pml='eread' pmo='pm -1av' pmy='eix-sync' pmu='pm -uDNav' pmU='pmu @world'
# Query #
#Belonged_file, Changelog, Depend, dependGraph
alias pq='eix' pqb='equery belongs' pqc='equery change' pqd='equery depends' pqg='equery depgraph'
#File, Installed, New, Use, UseGlobal
alias pqf='equery files'  pqi='equery list' pqn='eix-diff' pqu='equery uses' pqug='euse -i -g' 
## arch linux ##
#alias pd='pacdiff'
#alias pm='pacman' pmi='pm -S' pms='pm -Ss' pmr='pm -Rsn' pmu='pm -Syu' pmq='pm -Qe'
#alias pma='aura' pmai='pma -A' pmas='pma -Aas' pmar='pma -Rsn' pmau='pma -Ayu' pmau='pm -Qem' pmad='pma -Aw'
