#!/usr/bin/env bash

read -p "Enter log: " query

selected_commit=$(git log -S $query --oneline | fzf | awk '{print $1}') 

current_path=$(pwd)
parent_path=$(dirname "$current_path")

git worktree add $parent_path/$selected_commit $selected_commit

tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_commit -c $selected_commit
    exit 0
fi

if ! tmux has-session -t=$selected_commit 2> /dev/null; then
    tmux new-session -ds $selected_commit -c $selected_commit
fi

tmux switch-client -t $selected_commit
tmux send-keys -t $selected_commit "cd $parent_path/$selected_commit" C-m
tmux send-keys -t $selected_commit C-l

