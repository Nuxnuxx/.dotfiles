#!/bin/bash

# Loop through each folder not starting with a dot
for dir in */; do
    # Exclude folders starting with a dot
    if [[ ! "$dir" =~ ^\. ]]; then
        # Remove the trailing slash from the directory name
        dir_name=${dir%/}
        
        # Unstow the directory
        stow --adopt -D "$dir_name"
        
        # Stow the directory again
        stow --adopt "$dir_name"
    fi
done
