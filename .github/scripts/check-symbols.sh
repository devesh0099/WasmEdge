#!/bin/bash

# Create temporary files to store differences
EXTRA_IN_BUILD=$(mktemp)
EXTRA_IN_WHITELIST=$(mktemp)

# Find symbols that are in the new build but not in whitelist
comm -23 <(sort libwasmedge.txt) <(sort ./lib/api/whitelist.txt) > "$EXTRA_IN_BUILD"

# Find symbols that are in whitelist but not in the new build
comm -13 <(sort libwasmedge.txt) <(sort ./lib/api/whitelist.txt) > "$EXTRA_IN_WHITELIST"

# Matches both files
if [ ! -s "$EXTRA_IN_BUILD" ] && [ ! -s "$EXTRA_IN_WHITELIST" ]; then
    echo "No symbol differences found. Deleting the generated symbols file."
    rm libwasmedge.txt
    exit 0
fi

# If new build have new exposed symbols.
if [ -s "$EXTRA_IN_BUILD" ]; then
    echo "New build exposes new symbols. Please update whitelist.txt"
    echo "New symbols are:"
    cat "$EXTRA_IN_BUILD"
fi

# If new build removes old exposed symbols.
if [ -s "$EXTRA_IN_WHITELIST" ]; then
    echo "New build removes some old exposed symbols. Please remove these symbols from whitelist.txt:"
    cat "$EXTRA_IN_WHITELIST"
fi

# Cleanup
rm "$EXTRA_IN_BUILD" "$EXTRA_IN_WHITELIST"

# Default exit if error found.
exit 1