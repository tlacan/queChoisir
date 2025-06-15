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

# Run SwiftFormat to auto-fix formatting issues
echo "🎨 Running SwiftFormat..."
swiftformat "$PROJECT_ROOT" --config "$PROJECT_ROOT/.swiftformat"
SWIFTFORMAT_EXIT_CODE=$?

if [ $SWIFTFORMAT_EXIT_CODE -eq 0 ]; then
    echo "✅ SwiftFormat completed successfully"
else
    echo "⚠️  SwiftFormat completed with warnings (exit code: $SWIFTFORMAT_EXIT_CODE)"
fi

# Run SwiftLint to auto-fix linting issues
echo "🔍 Running SwiftLint auto-fix..."
cd "$PROJECT_ROOT" && swiftlint --fix --config "$PROJECT_ROOT/.swiftlint.yml"
SWIFTLINT_FIX_EXIT_CODE=$?

if [ $SWIFTLINT_FIX_EXIT_CODE -eq 0 ]; then
    echo "✅ SwiftLint auto-fix completed successfully"
else
    echo "⚠️  SwiftLint auto-fix completed with warnings (exit code: $SWIFTLINT_FIX_EXIT_CODE)"
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