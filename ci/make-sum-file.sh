#!/bin/bash
file="$1"

sha512sum "$file" > "$file.SHA512SUM"
