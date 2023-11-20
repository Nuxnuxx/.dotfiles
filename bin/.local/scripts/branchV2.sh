#!/usr/bin/env bash

selected_branch=$(git branch | fzf | awk '{print $1}')
if [ -z "$selected_branch" ]; then
		echo "No branch selected. Exiting..."
		exit 1
fi

git_status=$(git status --porcelain)
if [ -n "$git_status" ]; then
    echo "Changes detected. Stashing before checkout..."
    git stash
fi

git checkout "$selected_branch"
