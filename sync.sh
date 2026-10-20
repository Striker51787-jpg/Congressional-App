#!/usr/bin/env bash
# First, bring in the latest changes from main, replaying local commits on top.
# Then check code style and TypeScript types, stopping if either check fails.
# Stage all changes and commit them with the supplied description (or "Update").
# If there is nothing to commit, continue without creating an empty commit.
# Finally, send the commits to main. Stop immediately if any step fails.
set -euo pipefail

git pull --rebase origin main
npm run lint
npx tsc --noEmit
git add -A

if git diff --cached --quiet; then
  echo "Nothing to commit."
else
  git commit -m "${1:-Update}"
fi

git push origin main
