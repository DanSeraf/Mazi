#!/bin/bash

if ! [ -x "$(command -v love)" ]; then
  echo 'Error: love is not installed.' >&2
  exit 1
fi

echo 'Running Lua Maze'

love ./source
