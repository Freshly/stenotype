#!/bin/sh

yardoc \
  --format html \
  -o ./doc/stenotype_events \
  -e yard_extension.rb \
  --no-stats \
  --no-progress \
  --query 'type == :root or type == :stenotype_registry or type == :method_registry' \
  .
