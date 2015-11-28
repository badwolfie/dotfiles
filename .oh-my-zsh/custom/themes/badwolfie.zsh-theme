#local ret_status="%(?:%{$fg_bold[white]%}» :%{$fg_bold[red]%}» %s)"

function get_prompt() {
	git_root=$PWD

	while [[ $git_root != / && ! -e $git_root/.git ]]; do
		git_root=$git_root:h
	done

	if [[ $git_root = / ]]; then
		unset git_root
		prompt="%{$fg_bold[blue]%}"%m
	else
		prompt="%{$fg_bold[blue]%}git"
	fi
	  
	echo $prompt
}

PROMPT='$(get_prompt) %{$fg_bold[white]%}@ %{$fg_bold[magenta]%}%1~ %{$reset_color%}$(git_prompt_info)%{$fg_bold[white]%}»%b%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}⎇  %{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%b "
ZSH_THEME_GIT_PROMPT_DIRTY="[%{$fg_bold[red]%}✗%{$fg_bold[yellow]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="[%{$fg_bold[green]%}✔%{$fg_bold[yellow]%}]%{$reset_color%}"
#➜
