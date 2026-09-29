#!/bin/bash

# Configuration
MAX_BATCH_SIZE=100000000  # Max total transfer size per push (~100 MB)
MAX_FILE_SIZE=104857600   # Hard stop for individual files larger than 100MB
REMOTE="origin"
BRANCH=$(git branch --show-current)

echo "=== Starting Automated Unity Batch Sync ==="
echo "Target Branch: $BRANCH"
echo "Batch Size Limit: ~100 MB"

# Reset everything to starting point
git reset > /dev/null

# 1. First pass: scan for hard-limit individual large files (>100MB)
declare -A skipped_files
while IFS= read -r -d '' line; do
    file_path=$(echo "$line" | cut -c 4-)
    if [ -f "$file_path" ]; then
        file_size=$(stat -c%s "$file_path" 2>/dev/null || stat -f%z "$file_path" 2>/dev/null)
        if [ "$file_size" -gt "$MAX_FILE_SIZE" ]; then
            echo "⚠️  HARD SKIPPED (>100MB file): $file_path"
            skipped_files["$file_path"]=1
            skipped_files["${file_path}.meta"]=1
        fi
    fi
done < <(git status --porcelain -z)

# 2. Main processing loop for batching files
while true; do
    current_batch_size=0
    files_staged_count=0
    
    # Read the current unstaged status dynamically
    while IFS= read -r -d '' line; do
        status_flag=$(echo "$line" | cut -c 1-2)
        file_path=$(echo "$line" | cut -c 4-)
        
        if [ "${skipped_files[$file_path]}" ]; then
            continue
        fi
        
        file_size=0
        if [ -f "$file_path" ]; then
            file_size=$(stat -c%s "$file_path" 2>/dev/null || stat -f%z "$file_path" 2>/dev/null)
        fi
        
        if [ $files_staged_count -gt 0 ] && [ $((current_batch_size + file_size)) -gt $MAX_BATCH_SIZE ]; then
            break
        fi
        
        git add "$file_path"
        current_batch_size=$((current_batch_size + file_size))
        files_staged_count=$((files_staged_count + 1))
        
    done < <(git status --porcelain -z)
    
    if [ $files_staged_count -eq 0 ]; then
        echo "🎉 All eligible files have been successfully batched and pushed!"
        break
    fi
    
    echo "📦 Staged $files_staged_count files (Total Batch Volume: $(expr $current_batch_size / 1024 / 1024) MB)"
    COMMIT_MSG="Unity Batch Push - $(date '+%Y-%m-%d %H:%M:%S')"
    
    git commit -m "$COMMIT_MSG" > /dev/null
    echo "💾 Committed batch. Pushing to server..."
    
    if git push "$REMOTE" "$BRANCH"; then
        echo "✅ Batch push successful!"
        echo "----------------------------------------"
    else
        echo "❌ Push failed! Server rejected the batch. Stopping script execution."
        exit 1
    fi
    
    sleep 2
done
