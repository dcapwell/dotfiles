#!/bin/bash

# Script to rename a Git worktree containing submodules
# Usage: ./rename_worktree.sh <current_worktree_path> <new_worktree_path>

set -e  # Exit on any error

# Check if correct number of arguments provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <current_worktree_path> <new_worktree_path>"
    echo "Example: $0 ../foo ../bar"
    exit 1
fi

CURRENT_WORKTREE="$1"
NEW_WORKTREE="$2"

# Check if current worktree exists
if [ ! -d "$CURRENT_WORKTREE" ]; then
    echo "Error: Worktree directory '$CURRENT_WORKTREE' does not exist"
    exit 1
fi

# Check if new worktree path already exists
if [ -d "$NEW_WORKTREE" ]; then
    echo "Error: Directory '$NEW_WORKTREE' already exists"
    exit 1
fi

echo "Renaming worktree from '$CURRENT_WORKTREE' to '$NEW_WORKTREE'..."

# Step 1: Get the current branch name
echo "Getting current branch..."
cd "$CURRENT_WORKTREE"
BRANCH=$(git branch --show-current)
echo "Current branch: $BRANCH"

# Check for uncommitted changes
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Warning: You have uncommitted changes in the worktree."
    echo "Stashing changes..."
    git stash push -m "Temporary stash during worktree rename $(date)"
    STASHED=true
else
    STASHED=false
fi

# Go back to original directory
cd - > /dev/null

# Step 2: Remove the current worktree (force due to submodules)
echo "Removing current worktree..."
git worktree remove --force "$CURRENT_WORKTREE"

# Step 3: Create new worktree with the desired name
echo "Creating new worktree at '$NEW_WORKTREE'..."
git worktree add "$NEW_WORKTREE" "$BRANCH"

# Step 4: Initialize submodules in the new worktree
echo "Maybe initializing submodules..."
cd "$NEW_WORKTREE"
if [[ -e .gitmodules ]]; then
  git submodule update --init --recursive
fi

# Step 5: Restore stashed changes if any
if [ "$STASHED" = true ]; then
    echo "Restoring stashed changes..."
    git stash pop
fi

echo "Successfully renamed worktree from '$CURRENT_WORKTREE' to '$NEW_WORKTREE'"
echo "Current branch: $BRANCH"

# Show final status
echo -e "\nFinal status:"
git status --short

