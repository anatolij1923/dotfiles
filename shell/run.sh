#!/usr/bin/bash

SCSS="$HOME/dotfiles/shell/style.scss"
CSS="$HOME/dotfiles/shell/style.css"
APP="$HOME/dotfiles/shell/app.ts"

sass --watch "$SCSS":"$CSS" &
SASS_PID=$!

cleanup() {
    kill $SASS_PID
}
trap cleanup EXIT

ags run "$APP"
