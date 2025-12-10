#!/bin/env bash

# find a writable directory from PATH
bin_dir="$HOME/.local/bin"

if ! printf '%s\n' "$PATH" | grep -qE "(^|:)$bin_dir(:|$)"; then
  last=${PATH##*:}
  if [ -d "$last" ] && [ -r "$last" ] && [ -w "$last" ]; then
    bin_dir="$last"
  fi
fi

# if chezmoi is not installed
if ! command -v chezmoi &> /dev/null; then
    BINDIR=$bin_dir sh -c "$(curl -fsLS chezmoi.io/get)"
fi

# Initialize chemoi public dotfiles
mkdir -p ~/{.config,.cache}/chezmoi-{public,private}
$bin_dir/chezmoi \
  --source .local/share/chezmoi-public \
  --cache ~/.cache/chezmoi-public \
  --refresh-externals \
  init --apply https://github.com/justmiles/dotfiles.git

# Initialize chemoi private dotfiles
$bin_dir/chezmoi init \
  --exclude scripts \
  --apply https://github.com/justmiles/private-dotfiles.git
