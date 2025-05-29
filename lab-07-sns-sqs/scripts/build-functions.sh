#!/bin/bash

mkdir -p ../builds

find ../functions -type f -name "main.go" | while read -r file; do
  function_dir=$(dirname "$file")
  function_name=$(basename "$function_dir")
  
  echo $function_dir
  go build -C "$function_dir" -o "../../builds/$function_name/bootstrap" main.go
done