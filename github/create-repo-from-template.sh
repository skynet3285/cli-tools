#!/bin/bash

set -e

if ! command -v gh &> /dev/null
then
    echo "GitHub CLI (gh) is not installed. Please install it and try again."
    exit 1
fi

echo "Enter New Repository Name (REPO or OWNER/REPO):"
read NEW_REPO_NAME
echo "Enter Using Template Repository (OWNER/REPO):"
read TEMPLATE_REPO
echo "Do you want the repository to be private? (yes/no):"
read IS_PRIVATE
echo "Do you want to clone the repository after creation? (yes/no):"
read IS_CLONE

PRIVACY_FLAG=""
if [[ "$IS_PRIVATE" == "yes" ]]; then
  PRIVACY_FLAG="--private"
else
  PRIVACY_FLAG="--public"
fi

CLONE_FLAG=""
if [[ "$IS_CLONE" == "yes" ]]; then
  CLONE_FLAG="--clone"
fi

echo "Creating repository..."
gh repo create "$NEW_REPO_NAME" --template "$TEMPLATE_REPO" $PRIVACY_FLAG $CLONE_FLAG

echo "Repository '$NEW_REPO_NAME' created successfully!"