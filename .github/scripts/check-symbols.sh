#!/bin/bash

# Compare the two files
if sort ./lib/api/whitelist.symbols libwasmedge.symbols | uniq -u > /dev/null; then
   echo "No additional symbols exposed. Deleting the generated symbols file."
   rm libwasmedge.symbols
else 
   echo "Additional symbols exposed, please update the whitelist file."
   echo "Failing the build."
   exit 1
fi
