#!/bin/bash
set -e

BASE_URL="https://raw.githubusercontent.com/brtmax/git-committi/master"

PROJECT_ROOT="$(pwd)"

# Validate git repo
if [ ! -d "$PROJECT_ROOT/.git" ]; then
    echo "Error: This directory is not a Git repository."
    echo "Run: git init"
    exit 1
fi

HOOK_DEST="$PROJECT_ROOT/.git/hooks/pre-commit"
DIALOGUE_DIR="$PROJECT_ROOT/.git/dialogues"
ASCII_DIR="$PROJECT_ROOT/.git/ascii"

echo "Installing pre-commit hook..."

# Backup existing hook
if [ -f "$HOOK_DEST" ]; then
    cp "$HOOK_DEST" "$HOOK_DEST.backup"
    echo "Backed up existing hook → pre-commit.backup"
fi

# Download hook
curl -fsSL "$BASE_URL/hooks/pre-commit" -o "$HOOK_DEST"
chmod +x "$HOOK_DEST"

# Create git storage dirs
mkdir -p "$DIALOGUE_DIR" "$ASCII_DIR"

echo "Downloading dialogues..."
curl -fsSL "$BASE_URL/dialogues/" | grep -o 'href="[^"]*\.txt"' | sed 's/href="//;s/"//' | while read -r FILE; do
    curl -fsSL "$BASE_URL/dialogues/$FILE" -o "$DIALOGUE_DIR/$FILE"
done

echo "Downloading ASCII art..."
curl -fsSL "$BASE_URL/ascii/" | grep -o 'href="[^"]*\.txt"' | sed 's/href="//;s/"//' | while read -r FILE; do
    curl -fsSL "$BASE_URL/ascii/$FILE" -o "$ASCII_DIR/$FILE"
done

# Initialize shame file
SHAME_FILE="$PROJECT_ROOT/.git/commit_shame_file"
if [ ! -f "$SHAME_FILE" ]; then
    echo "offenses=0" > "$SHAME_FILE"
fi

echo ""
echo "committi insult engine is now active."

