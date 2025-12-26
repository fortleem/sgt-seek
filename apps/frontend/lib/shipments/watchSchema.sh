#!/bin/bash
while true; do
  npx graphql-codegen --config "/Users/tonsy/Documents/sgt-seek/apps/frontend/codegen.yml" > /dev/null 2>&1
  sleep 30
done
