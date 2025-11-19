#!/bin/bash

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
HOOK_SRC="$PROJECT_ROOT/hooks/pre-commit"
DIALOGUE_SRC="$PROJECT_ROOT/dialogues"

#   Validate Git repo
if [ ! -d "$PROJECT_ROOT/.git" ]; then
    echo "❌ Error: This directory is not a Git repository."
    echo "Run: git init"
    exit 1
fi

#   Install pre-commit hook
HOOK_DEST="$PROJECT_ROOT/.git/hooks/pre-commit"

# Backup existing pre-commit hook if present
if [ -f "$HOOK_DEST" ]; then
    echo "Existing pre-commit hook found. Backing it up to pre-commit.backup"
    cp "$HOOK_DEST" "$HOOK_DEST.backup"
fi

echo "Installing pre-commit hook..."
cp "$HOOK_SRC" "$HOOK_DEST"
chmod +x "$HOOK_DEST"

#   Create internal git storage dirs
mkdir -p "$PROJECT_ROOT/.git/dialogues"
mkdir -p "$PROJECT_ROOT/.git/ascii"

echo "Copying dialogues..."
cp "$DIALOGUE_SRC"/*.txt "$PROJECT_ROOT/.git/dialogues/"

echo "Copying ASCII art..."
cp "$ASCII_SRC"/*.txt "$PROJECT_ROOT/.git/ascii/"

#   Initialize shame file
SHAME_FILE="$PROJECT_ROOT/.git/commit_shame_file"
if [ ! -f "$SHAME_FILE" ]; then
    echo "Initializing commit_shame_file..."
    echo "offenses=0" > "$SHAME_FILE"
fi

echo ""
echo "Installation complete!"
echo "Your committi insult engine is now active."
