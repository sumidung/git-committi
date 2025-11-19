#!/bin/bash
set -e

BASE_URL="https://raw.githubusercontent.com/brtmax/git-committi/master"

PROJECT_ROOT="$(pwd)"
HOOK_URL="https://raw.githubusercontent.com/brtmax/git-committi/master/hooks/pre-commit"
ZIP_URL="https://github.com/brtmax/git-committi/archive/refs/heads/master.zip"
TEMP_ZIP="/tmp/git-committi.zip"

# Validate git repo
if [ ! -d "$PROJECT_ROOT/.git" ]; then
    echo "Error: This directory is not a Git repository."
    echo "Run: git init"
    exit 1
fi

HOOK_DEST="$PROJECT_ROOT/.git/hooks/pre-commit"
DIALOGUE_DIR="$PROJECT_ROOT/.git/dialogues"
ASCII_DIR="$PROJECT_ROOT/.git/ascii"
SHAME_FILE="$PROJECT_ROOT/.git/commit_shame_file"

echo "Installing pre-commit hook..."

# Backup existing hook
if [ -f "$HOOK_DEST" ]; then
    cp "$HOOK_DEST" "$HOOK_DEST.backup"
    echo "Backed up existing hook → pre-commit.backup"
fi

echo "Downloading pre-commit hook..."
curl -fsSL "$HOOK_URL" -o "$HOOK_DEST"
chmod +x "$HOOK_DEST"

# Create directories
mkdir -p "$DIALOGUE_DIR" "$ASCII_DIR"

echo "Downloading dialogues and ASCII art..."
curl -L "$ZIP_URL" -o "$TEMP_ZIP"

# Extract only dialogues and ascii directories
unzip -o "$TEMP_ZIP" "git-committi-master/dialogues/*" -d /tmp/
unzip -o "$TEMP_ZIP" "git-committi-master/ascii/*" -d /tmp/

# Move extracted files to .git
cp /tmp/git-committi-master/dialogues/* "$DIALOGUE_DIR/"
cp /tmp/git-committi-master/ascii/* "$ASCII_DIR/"

# Clean up temp
rm -rf /tmp/git-committi-master
rm -f "$TEMP_ZIP"

# Initialize shame file
if [ ! -f "$SHAME_FILE" ]; then
    echo "offenses=0" > "$SHAME_FILE"
fi

echo ""
echo "committi insult engine is now active."

