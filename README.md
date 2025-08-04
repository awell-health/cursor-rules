# Shared Cursor Rules

This repository contains shared cursor rules that can be integrated into multiple projects. These rules help maintain consistency across different codebases by providing reusable AI assistant instructions and behaviors.

## 📁 Repository Structure

```
cursor-rules/
├── sync-shared-rules.sh          # Script to sync rules to your project
├── README.md                     # This file
├── three-step-issue-resolution.mdc  # Example cursor rule
└── *.mdc                         # Additional cursor rule files
```

## 🚀 Quick Setup

### 1. Add as Submodule

In your target repository, add this repository as a git submodule in the `.cursor/shared_rules` directory:

```bash
# Navigate to your project root
cd your-project/

# Add the submodule
git submodule add https://github.com/awell-health/cursor-rules.git .cursor/shared_rules

# Commit the submodule addition
git add .gitmodules .cursor/shared_rules
git commit -m "Add shared cursor rules submodule"
```

### 2. Sync Rules

Run the sync script to copy shared rules to your local cursor rules directory:

```bash
# Make the script executable (first time only)
chmod +x .cursor/shared_rules/sync-shared-rules.sh

# Run the sync script
./.cursor/shared_rules/sync-shared-rules.sh
```

## 🔄 Keeping Rules Updated

### Manual Sync

To get the latest shared rules, simply run the sync script again:

```bash
./.cursor/shared_rules/sync-shared-rules.sh
```



## 📋 What the Sync Script Does

1. **Updates Submodule**: Pulls the latest changes from the shared rules repository
2. **Creates Directory**: Ensures `.cursor/rules` directory exists
3. **Copies Rules**: Copies all `.mdc` files from shared rules to local rules
4. **Provides Feedback**: Shows detailed status and success messages



---

**Note**: This system assumes your cursor rules are stored as `.mdc` files in the `.cursor/rules` directory, which is the standard convention for Cursor AI editor.