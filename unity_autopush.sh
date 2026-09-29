#!/bin/bash

# Configuration
MAX_SIZE=104857600  # 100 MB in bytes
REMOTE="origin"
BRANCH=$(git branch --show-current)

echo "=== Starting Automated Unity Sync for Branch: $BRANCH ==="

# Reset staging area to ensure a fresh, controlled execution
git reset > /dev/null

# Array to keep track of files skipped due to size limits
declare -A skipped_files

echo "🔍 Scanning Unity files and checking sizes..."

# Process tracked deletions, renames, and modified files safely using null-delimiters
while IFS= read -r -d '' line; do
    # Extract the file path (stripping out the Git status flag)
    file_path=$(echo "$line" | cut -c 4-)
    
    # Handle files that exist on disk
    if [ -f "$file_path" ]; then
        file_size=$(stat -c%s "$file_path" 2>/dev/null || stat -f%z "$file_path" 2>/dev/null)
        
        if [ "$file_size" -gt "$MAX_SIZE" ]; then
            echo "⚠️  SKIPPED (>100MB): $file_path"
            skipped_files["$file_path"]=1
            # Mark its matching Unity .meta file to be skipped as well
            skipped_files["${file_path}.meta"]=1
        fi
    fi
done < <(git status --porcelain -z)

# Second pass: Stage files that passed the size filter
while IFS= read -r -d '' line; do
    file_path=$(echo "$line" | cut -c 4-)
    
    # Skip if flagged during the size check
    if [ "${skipped_files[$file_path]}" ]; then
        continue
    fi
    
    # Stage modifications, additions, and deletions
    git add "$file_path"
done < <(git status --porcelain -z)

# Check if anything was safely staged
if git diff --cached --quiet; then
    echo "❌ No eligible files under 100MB found to commit."
    exit 0
fi

# Print summary of staged files
echo ""
echo "📦 Staging completed. Ready to commit."

# Auto-generate a timestamped Unity commit message
COMMIT_MSG="Unity Auto-Sync - $(date '+%Y-%m-%d %H:%M:%S')"

echo "💾 Committing changes: '$COMMIT_MSG'..."
git commit -m "$COMMIT_MSG"

echo "🚀 Pushing directly to $REMOTE/$BRANCH..."
git push "$REMOTE" "$BRANCH"

echo "✅ Auto-push complete!"


