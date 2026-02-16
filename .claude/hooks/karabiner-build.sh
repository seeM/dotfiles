#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ "$FILE_PATH" == */karabiner/* ]]; then
  npm run build --prefix "$CLAUDE_PROJECT_DIR/karabiner"
fi