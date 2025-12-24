#!/bin/bash
set -e

# Post-tool-use hook that tracks edited files and their repos
# This runs after Edit, MultiEdit, or Write tools complete successfully

# Read tool information from stdin
tool_info=$(cat)

# Extract relevant data
tool_name=$(echo "$tool_info" | jq -r '.tool_name // empty')
file_path=$(echo "$tool_info" | jq -r '.tool_input.file_path // empty')
session_id=$(echo "$tool_info" | jq -r '.session_id // empty')

# Skip if not an edit tool or no file path
if [[ ! "$tool_name" =~ ^(Edit|MultiEdit|Write)$ ]] || [[ -z "$file_path" ]]; then
  exit 0
  fi

  # Skip markdown files
  if [[ "$file_path" =~ \.(md|markdown)$ ]]; then
    exit 0
    fi

    # Create cache directory in project
    cache_dir="$CLAUDE_PROJECT_DIR/.claude/tsc-cache/${session_id:-default}"
    mkdir -p "$cache_dir"

    # Log edited file
    echo "$(date +%s):$file_path" >> "$cache_dir/edited-files.log"

    exit 0
