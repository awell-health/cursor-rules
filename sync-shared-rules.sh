#!/bin/bash

# Sync Shared Cursor Rules
# This script pulls the latest shared cursor rules and copies them to the local rules directory

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "This script must be run from the root of a git repository"
    exit 1
fi

# Define directories
SHARED_RULES_DIR=".cursor/shared_rules"
LOCAL_RULES_DIR=".cursor/rules"

print_status "Starting cursor rules sync..."

# Check if shared_rules directory exists
if [ ! -d "$SHARED_RULES_DIR" ]; then
    print_error "Shared rules directory '$SHARED_RULES_DIR' not found!"
    print_error "Please add the cursor-rules repository as a submodule first:"
    print_error "  git submodule add https://github.com/awell-health/cursor-rules.git $SHARED_RULES_DIR"
    exit 1
fi

# Check if it's a git submodule
if [ ! -f "$SHARED_RULES_DIR/.git" ] && [ ! -d "$SHARED_RULES_DIR/.git" ]; then
    print_warning "Directory '$SHARED_RULES_DIR' exists but doesn't appear to be a git submodule"
    print_warning "Continuing anyway..."
else
    print_status "Updating shared rules submodule..."
    
    # Initialize submodules if needed
    git submodule update --init --recursive
    
    # Pull latest changes from the submodule
    cd "$SHARED_RULES_DIR"
    git fetch origin
    git checkout main 2>/dev/null || git checkout master 2>/dev/null || {
        print_error "Could not checkout main or master branch in submodule"
        exit 1
    }
    git pull origin HEAD
    cd - > /dev/null
    
    print_success "Submodule updated successfully"
fi

# Create local rules directory if it doesn't exist
if [ ! -d "$LOCAL_RULES_DIR" ]; then
    print_status "Creating local rules directory: $LOCAL_RULES_DIR"
    mkdir -p "$LOCAL_RULES_DIR"
fi

# Count files to copy
rule_files=$(find "$SHARED_RULES_DIR" -name "*.mdc" -type f 2>/dev/null || true)
file_count=$(echo "$rule_files" | grep -c "." 2>/dev/null || echo "0")

if [ "$file_count" -eq 0 ]; then
    print_warning "No cursor rule files (*.mdc) found in $SHARED_RULES_DIR"
    print_status "Sync completed - nothing to copy"
    exit 0
fi

print_status "Found $file_count cursor rule file(s) to sync"

# Copy all .mdc files from shared_rules to rules
copied_count=0
while IFS= read -r file; do
    if [ -n "$file" ]; then
        filename=$(basename "$file")
        print_status "Copying: $filename"
        cp "$file" "$LOCAL_RULES_DIR/"
        ((copied_count++))
    fi
done <<< "$rule_files"

print_success "Successfully copied $copied_count cursor rule(s) to $LOCAL_RULES_DIR"

# List the copied files
print_status "Current cursor rules:"
ls -la "$LOCAL_RULES_DIR"/*.mdc 2>/dev/null || print_warning "No .mdc files found in $LOCAL_RULES_DIR"

print_success "Cursor rules sync completed!"
print_status "Your shared cursor rules are now up to date and ready to use."