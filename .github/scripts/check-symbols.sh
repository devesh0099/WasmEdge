#!/bin/bash

# Compare the two files
if diff -q whitelist.symbols libwasmedge.symbols > /dev/null; then
    echo "No additional symbols exposed. Deleting the generated symbols file."
    rm libwasmedge.symbols
else
    echo "Additional symbols found!"
    echo "Failing the build."
    exit 1  # Fails the build
fi
