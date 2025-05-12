#!/bin/bash
#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Start Up
# /home/powers/.local/bin/wrappedhl
if uwsm check may-start && uwsm select; then
	exec uwsm start default
fi

for file in ~/.shell/autoload/*; do
  source $file
  eval "$(basename "$file")() ( $(cat "$file"); )"
done

# Add in git branch information to prompt
function __git_branch() {
  git rev-parse --is-inside-work-tree &>/dev/null || return
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  echo " ($branch)"
}


# Prompt formatter
function __prompt() {
  local status=$?
  local color=$HOST_COLOR
  [ $status -ne 0 ] && color=9  # Red on error

  # Conda environment (if active)
  local conda_env=""
  if [ -n "$CONDA_DEFAULT_ENV" ]; then
    #conda_env="\[\033[1;32m\](${CONDA_DEFAULT_ENV}) "  # green
    conda_env="\[\033[00m\](${CONDA_DEFAULT_ENV}) "  # green
  fi

  # Components
  local user_host="\[\033[38;5;${color}m\]\u@\h"
  local cwd="\[\033[38;5;151m\]\w"
  local git="\[\033[1;35m\]$(__git_branch)"
  local reset="\[\033[0m\]"

  # Final prompt string
  PS1="${conda_env}${user_host} ${cwd}${git} ${reset}\n\[\033[00m\]╰─λ "
}

export PROMPT_COMMAND=__prompt


# Created by `pipx` on 2025-04-29 17:45:55
export PATH="$PATH:$HOME/.local/bin"
