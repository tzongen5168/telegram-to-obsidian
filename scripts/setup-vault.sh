#!/bin/bash
# Setup PARA folder structure in an Obsidian vault
# Usage: ./setup-vault.sh /path/to/your/obsidian/vault

VAULT_PATH="${1:?Usage: ./setup-vault.sh /path/to/your/obsidian/vault}"

if [ ! -d "$VAULT_PATH" ]; then
  echo "Error: Directory $VAULT_PATH does not exist."
  echo "Please create your Obsidian vault first, then run this script."
  exit 1
fi

echo "Setting up PARA structure in: $VAULT_PATH"

mkdir -p "$VAULT_PATH/00-Inbox"
mkdir -p "$VAULT_PATH/10-Projects"
mkdir -p "$VAULT_PATH/20-Areas"
mkdir -p "$VAULT_PATH/30-Resources"
mkdir -p "$VAULT_PATH/40-Archive"
mkdir -p "$VAULT_PATH/50-Templates"

echo "Done. Folder structure:"
find "$VAULT_PATH" -maxdepth 1 -type d | sort
echo ""
echo "You can customize subcategories by creating folders under 20-Areas/ and 30-Resources/."
echo "Example:"
echo "  mkdir -p $VAULT_PATH/30-Resources/AI"
echo "  mkdir -p $VAULT_PATH/30-Resources/Business"
echo "  mkdir -p $VAULT_PATH/20-Areas/Marketing"
