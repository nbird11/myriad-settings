# Enabling and setting git info var to be used in prompt config.
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
# This line obtains information from the vcs.
zstyle ':vcs_info:git*' formats 'on branch
  (%b)'
precmd() {
  vcs_info
  vcs_branch=''
  # Config for the prompt. PS1 synonym.
  if [[ -n $vcs_info_msg_0_ ]]; then
    vcs_branch=" ${vcs_info_msg_0_}"
  fi
}

# Enable substitution in the prompt.
setopt PROMPT_SUBST

PROMPT='%n@[${PWD/#$HOME/~}]${vcs_branch} %# '
