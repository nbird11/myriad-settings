alias py='python3'
alias pip='pip3'

# OLD In case I want to go back to a simpler prompt
# # Enabling and setting git info var to be used in prompt config.
# autoload -Uz vcs_info
# zstyle ':vcs_info:*' enable git svn
# # This line obtains information from the vcs.
# zstyle ':vcs_info:git*' formats 'on branch
#   (%b)'
# precmd() {
#   vcs_info
#   vcs_branch=''
#   # Config for the prompt. PS1 synonym.
#   if [[ -n $vcs_info_msg_0_ ]]; then
#     vcs_branch=" ${vcs_info_msg_0_}"
#   fi
# }
#
# # Enable substitution in the prompt.
# setopt PROMPT_SUBST
#
# PROMPT='%n@[${PWD/#$HOME/~}]${vcs_branch} %# '
# END OLD

# Enable colored output for ls
export CLICOLOR=YES # MacOS
if which dircolors &>/dev/null; then
  alias ls="ls --color=auto"
fi

# Workaround for zsh 5.2 release
autoload +X VCS_INFO_nvcsformats
functions[VCS_INFO_nvcsformats]=${functions[VCS_INFO_nvcsformats]/local -a msgs/}
# # Lines for vcs_info prompt configuration
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%{%F{green}%B%}●%{%b%f%}'
zstyle ':vcs_info:*' unstagedstr '%{%F{red}%B%}●%{%b%f%}'
zstyle ':vcs_info:*' formats '%{%F{yellow}%}%45<…<%R%<</%{%f%}%{%F{cyan}%}(%25>…>%b%<<)%{%f%}%{%F{cyan}%}%S%{%f%}%c%u'
zstyle ':vcs_info:*' actionformats '%{%F{cyan}%}%45<…<%R%<</%{%f%}%{%F{red}%}(%a|%m)%{%f%}%{%F{cyan}%}%S%{%f%}%c%u'
zstyle ':vcs_info:*' nvcsformats '%{%F{cyan}%}%~%{%f%}'
zstyle ':vcs_info:git:*' patch-format '%10>…>%p%<< (%n applied)'
zstyle ':vcs_info:*+set-message:*' hooks home-path
function +vi-home-path() {
  # Replace $HOME with ~
  hook_com[base]="$(echo ${hook_com[base]} | sed "s/${HOME:gs/\//\\\//}/~/" )"
}
zstyle ':vcs_info:git+post-backend:*' hooks git-remote-staged
function +vi-git-remote-staged() {
  # Show "unstaged" when changes are not staged or not committed
  # Show "staged" when last committed is not pushed
  #
  # See original VCS_INFO_get_data_git for implementation details

  # Set "unstaged" when git reports either staged or unstaged changes
  if (( gitstaged || gitunstaged )) ; then
    gitunstaged=1
  fi

  # Set "staged" when current HEAD is not present in the remote branch
  if (( querystaged )) && \
     [[ "$(${vcs_comm[cmd]} rev-parse --is-inside-work-tree 2> /dev/null)" == 'true' ]] ; then
      # Default: off - these are potentially expensive on big repositories
      if ${vcs_comm[cmd]} rev-parse --quiet --verify HEAD &> /dev/null ; then
          gitstaged=1
          if ${vcs_comm[cmd]} status --branch --short | head -n1 | grep -v ahead > /dev/null ; then
            gitstaged=
          fi
      fi
  fi

  hook_com[staged]=$gitstaged
  hook_com[unstaged]=$gitunstaged
}
autoload -Uz vcs_info
function precmd() { vcs_info }
setopt prompt_subst
PROMPT='%(?..%{%F{red}%}%?%{%f%} )%{%F{magenta}%}%n%{%f%}@%{%F{red}%}%m%{%f%}:${vcs_info_msg_0_}%{%B%} %(!.#.%#)%{%b%E%} '
# End of lines for vcs_info prompt configuration
