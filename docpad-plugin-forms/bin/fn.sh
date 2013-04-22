#!/usr/bin/env bash
# This script was generated by a tool. Run ../bootstrap.sh to regenerate
# Here we place a multitude of handy functions - not everyone has OMZ

# Clean docpad environment output/ directory (out/)
dpclean() { docpad clean; }

# Create a temporary folder and bootstrap a skeleton
dptemp() { cd $(mktemp -d); docpad skeleton; }

