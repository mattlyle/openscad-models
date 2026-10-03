#!/usr/bin/env bash
# usage: wt <branch-name>
#
# Creates a new git worktree at ~/projects/openscad-models-<branch-name>,
# checked out to a branch of the same name (creating it if it doesn't
# already exist), then seeds it with a copy of TEMPLATE.scad named after
# the branch so there's already a scaffold file ready to edit.
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: wt <branch-name>" >&2
  exit 1
fi

branch="$1"
path="$HOME/projects/openscad-models-${branch}"

if git show-ref --verify --quiet "refs/heads/${branch}"; then
  # Branch already exists — just attach a worktree to it.
  git worktree add "$path" "$branch"
else
  # New branch, created off current HEAD.
  git worktree add -b "$branch" "$path"
fi

template="$path/TEMPLATE.scad"
scaffold="$path/${branch}.scad"

if [[ -f "$template" ]]; then
  cp "$template" "$scaffold"
  echo "Scaffolded: $scaffold"
else
  echo "Warning: TEMPLATE.scad not found in worktree, skipping scaffold copy." >&2
fi
