#!/bin/bash

REMOTE="origin"
BRANCH=$(git branch --show-current)

echo "=== Starting Simple 10-File Batch Push ==="

# First, break up that old 4GB commit if you haven't already
git reset > /dev/null

while true; do
    files_staged=0
    
    # Read modified/deleted/untracked files one by one
    while IFS= read -r -d '' line; do
        # Extract the file path
        file_path=$(echo "$line" | cut -c 4-)
        
        # Stage the file
        git add "$file_path"
        files_staged=$((files_staged + 1))
        
        # Stop exactly at 10 files
        if [ "$files_staged" -eq 10 ]; then
            break
        fi
    done < <(git status --porcelain -z)
    
    # Break out of the main loop if no files are left to stage
    if [ "$files_staged" -eq 0 ]; then
        echo "🎉 All files have been successfully pushed in 10-file increments!"
        break
    fi
    
    echo "📦 Staged $files_staged files. Committing..."
    git commit -m "Batch sync 10 files - $(date '+%H:%M:%S')" > /dev/null
    
    echo "🚀 Pushing batch to $REMOTE/$BRANCH..."
    if git push "$REMOTE" "$BRANCH"; then
        echo "✅ Push successful!"
        echo "------------------------------------"
    else
        echo "❌ Push failed! Stopping script to prevent loop errors."
        exit 1
    fi
    
    # Optional 1 second cool-down between pushes
    sleep 1
done
