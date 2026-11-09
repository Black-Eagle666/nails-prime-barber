#!/bin/zsh
# Stages only the public site files + the worker into a temp folder and deploys from there.
set -euo pipefail
SITE="$(cd "$(dirname "$0")/.." && pwd)"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$STAGE/public"
cd "$SITE"
git archive HEAD index.html ochrana-osobnich-udaju.html manikura-usti-nad-orlici.html kurzy-manikury.html barber-usti-nad-orlici.html sitemap.xml _headers robots.txt fonts \
  favicon.svg favicon-32.png apple-touch-icon.png '*.jpg' | tar -x -C "$STAGE/public"
git archive HEAD cloudflare/worker.js cloudflare/wrangler.jsonc | tar -x -C "$STAGE" --strip-components=1
ls -a "$STAGE/public"
cd "$STAGE"
PATH="$HOME/.local/node22/bin:$PATH" npx --prefix "$HOME/Documents/fitnessmama-platform" wrangler deploy
