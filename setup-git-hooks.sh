#!/bin/bash

# Setup script for Git hooks
# This script sets up the pre-commit hook to run Swift formatting and linting

set -e

echo "🔧 Setting up Git hooks for Swift formatting and linting..."

# Get the repository root directory
REPO_ROOT="$(git rev-parse --show-toplevel)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# Copy or create the pre-commit hook
cat > "$HOOKS_DIR/pre-commit" << 'EOF'
#!/bin/bash

# Git pre-commit hook that runs Swift formatting and linting
# This hook automatically runs before every git commit

# Get the repository root directory
REPO_ROOT="$(git rev-parse --show-toplevel)"

# Path to our pre-commit script
PRE_COMMIT_SCRIPT="$REPO_ROOT/pre-commit-format.sh"

# Check if our pre-commit script exists
if [ ! -f "$PRE_COMMIT_SCRIPT" ]; then
    echo "❌ Pre-commit script not found at: $PRE_COMMIT_SCRIPT"
    echo "Please ensure pre-commit-format.sh exists in the repository root"
    exit 1
fi

# Make sure the script is executable
chmod +x "$PRE_COMMIT_SCRIPT"

# Run our pre-commit formatting and linting script
echo "🔧 Running pre-commit Swift formatting and linting..."
"$PRE_COMMIT_SCRIPT"
EXIT_CODE=$?

# If the script failed, prevent the commit
if [ $EXIT_CODE -ne 0 ]; then
    echo "❌ Pre-commit checks failed. Please fix the issues above before committing."
    echo "You can run './format-code.sh' to apply formatting fixes."
    exit $EXIT_CODE
fi

echo "✅ Pre-commit checks passed. Proceeding with commit..."
exit 0
EOF

# Make the hook executable
chmod +x "$HOOKS_DIR/pre-commit"

# Make sure our format scripts are executable
chmod +x "$REPO_ROOT/pre-commit-format.sh"
chmod +x "$REPO_ROOT/format-code.sh"

echo "✅ Git hooks setup complete!"
echo ""
echo "📋 What was configured:"
echo "   • Pre-commit hook: $HOOKS_DIR/pre-commit"
echo "   • Format checker: $REPO_ROOT/pre-commit-format.sh"
echo "   • Format applier: $REPO_ROOT/format-code.sh"
echo ""
echo "🎯 How it works:"
echo "   • Every time you run 'git commit', the pre-commit hook will automatically:"
echo "     1. Check if SwiftFormat would make formatting changes"
echo "     2. Check if SwiftLint would make auto-fix changes"
echo "     3. If formatting is needed, automatically apply fixes"
echo "     4. Block the commit and ask you to re-stage the formatted code"
echo "     5. Validate the code with SwiftLint for remaining issues"
echo ""
echo "🚀 To test the setup, try making a commit!"
echo "🔧 To format your code manually: ./format-code.sh"