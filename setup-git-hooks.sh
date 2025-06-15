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
    echo "You can run './pre-commit-format.sh' manually to fix formatting issues."
    exit $EXIT_CODE
fi

echo "✅ Pre-commit checks passed. Proceeding with commit..."
exit 0
EOF

# Make the hook executable
chmod +x "$HOOKS_DIR/pre-commit"

# Make sure our format script is executable
chmod +x "$REPO_ROOT/pre-commit-format.sh"

echo "✅ Git hooks setup complete!"
echo ""
echo "📋 What was configured:"
echo "   • Pre-commit hook: $HOOKS_DIR/pre-commit"
echo "   • Format script: $REPO_ROOT/pre-commit-format.sh"
echo ""
echo "🎯 How it works:"
echo "   • Every time you run 'git commit', the pre-commit hook will automatically:"
echo "     1. Run SwiftFormat to fix code formatting"
echo "     2. Run SwiftLint to auto-fix linting issues"
echo "     3. Validate the code with SwiftLint"
echo "     4. Prevent commit if any issues remain that need manual fixing"
echo ""
echo "🚀 To test the setup, try making a commit!"
echo "🔧 To run formatting manually: ./pre-commit-format.sh"