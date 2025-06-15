#!/bin/bash

# Pre-commit script for Swift formatting and linting
# This script runs SwiftFormat and SwiftLint to auto-fix code formatting and style issues

set -e  # Exit on any error

echo "🔧 Running pre-commit Swift formatting and linting..."

# Check if SwiftFormat is installed
if ! command -v swiftformat &> /dev/null; then
    echo "❌ SwiftFormat not found. Please install it with: brew install swiftformat"
    exit 1
fi

# Check if SwiftLint is installed
if ! command -v swiftlint &> /dev/null; then
    echo "❌ SwiftLint not found. Please install it with: brew install swiftlint"
    exit 1
fi

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📂 Project root: $PROJECT_ROOT"

# Check if there are any staged changes before formatting
echo "🔍 Checking if formatting changes will be needed..."
STAGED_FILES=$(git diff --cached --name-only --diff-filter=AM | grep -E '\.(swift)$' || true)

if [ -z "$STAGED_FILES" ]; then
    echo "✅ No Swift files staged for commit"
else
    echo "📁 Swift files to check: $STAGED_FILES"
    
    # Check if SwiftFormat would make changes (dry run)
    echo "🎨 Checking SwiftFormat formatting..."
    swiftformat "$PROJECT_ROOT" --config "$PROJECT_ROOT/.swiftformat" --dryrun --quiet
    SWIFTFORMAT_DRYRUN_EXIT_CODE=$?
    
    # Check if SwiftLint would make changes
    echo "🔍 Checking SwiftLint auto-fix..."
    cd "$PROJECT_ROOT"
    
    # Create a temporary copy to test SwiftLint changes
    TEMP_OUTPUT=$(mktemp)
    swiftlint --fix --config "$PROJECT_ROOT/.swiftlint.yml" --quiet > "$TEMP_OUTPUT" 2>&1
    SWIFTLINT_WOULD_CHANGE=false
    
    # Check if git working directory is clean after SwiftLint fix
    if ! git diff --quiet; then
        SWIFTLINT_WOULD_CHANGE=true
        # Restore the original state for now
        git checkout -- .
    fi
    
    rm -f "$TEMP_OUTPUT"
    
    # If either tool would make changes, apply them automatically
    if [ $SWIFTFORMAT_DRYRUN_EXIT_CODE -ne 0 ] || [ "$SWIFTLINT_WOULD_CHANGE" = true ]; then
        echo "🔧 Formatting issues detected. Auto-fixing..."
        
        # Run SwiftFormat to fix formatting
        echo "🎨 Running SwiftFormat..."
        swiftformat "$PROJECT_ROOT" --config "$PROJECT_ROOT/.swiftformat"
        
        # Run SwiftLint to auto-fix issues
        echo "🔍 Running SwiftLint auto-fix..."
        swiftlint --fix --config "$PROJECT_ROOT/.swiftlint.yml" --quiet
        
        echo "✅ Code has been automatically formatted!"
        echo "📝 Please review the changes and re-stage them:"
        echo "   git add ."
        echo "   git commit"
        exit 1
    fi
    
    echo "✅ No formatting changes needed"
fi

# Run SwiftLint to check for remaining issues
echo "🔍 Running SwiftLint validation..."
cd "$PROJECT_ROOT" && swiftlint --config "$PROJECT_ROOT/.swiftlint.yml"
SWIFTLINT_CHECK_EXIT_CODE=$?

if [ $SWIFTLINT_CHECK_EXIT_CODE -eq 0 ]; then
    echo "✅ SwiftLint validation passed - no issues found"
else
    echo "❌ SwiftLint found issues that need manual fixing (exit code: $SWIFTLINT_CHECK_EXIT_CODE)"
    echo "Please review and fix the remaining SwiftLint issues before committing"
    exit $SWIFTLINT_CHECK_EXIT_CODE
fi

echo "🎉 All formatting and linting checks passed!"
echo "Your code is now formatted and ready for commit."