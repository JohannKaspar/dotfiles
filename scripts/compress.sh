#!/usr/bin/env zsh

set -e

# Find 7-Zip command
if command -v 7zz >/dev/null 2>&1; then
  sevenzip="7zz"
elif command -v 7z >/dev/null 2>&1; then
  sevenzip="7z"
else
  echo "Error: 7-Zip is not installed."
  echo "Install it with:"
  echo "  brew install sevenzip"
  exit 1
fi

files=()

# If files were passed directly, use them
if [[ $# -gt 0 ]]; then
  files=("$@")
else
  echo "Drag and drop files/folders into this Terminal window."
  echo "Press Enter after each drop, or drop several at once."
  echo "When finished, press Ctrl+D."
  echo

  while IFS= read -r line; do
    [[ -z "$line" ]] && continue

    # Parse shell-escaped paths created by drag and drop
    dragged_items=("${(@Q)${(z)line}}")
    files+=("${dragged_items[@]}")
  done
fi

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No files or folders selected."
  exit 1
fi

output="secure_archive_$(date +%Y%m%d_%H%M%S).7z"

echo
echo "Creating encrypted archive:"
echo "  $output"
echo

"$sevenzip" a -p -mhe=on "$output" "${files[@]}"

echo
echo "Done:"
echo "  $output"

