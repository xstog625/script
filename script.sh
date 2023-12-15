#!/bin/bash

declare -A MAP=(
    ["Dockerfile*"]="dockerfile"
    ["*.kt"]="kotlin"
    ["*.php"]="php"
    ["*.rb"]="ruby"
    ["*.swift"]="swift"
    ["*.tf"]="terraform"
    ["*.ts"]="typescript"
    ["*.go"]="go"
    ["*.java"]="java"
    ["*.js"]="javascript"
    ["*.yaml"]="yaml"
    ["*.yml"]="yaml"
    ["*.py"]="python"
    ["*.scl"]="scala"
)

config_args=()

for ext in "${!MAP[@]}"; do
    find . -type f -name "${ext}" -exec echo "Found: {}" \;
    if find . -type f -name "${ext}" >/dev/null 2>&1; then
        config_args+=("--config" "../semgrep-rules/${MAP[$ext]}")
        echo config_args
    fi
done

if [ "${#config_args[@]}" -eq 0 ]; then
    echo "No matching files found for semgrep scan."
    exit 1
fi

semgrep ci --exclude semgrep-rules/ --metrics=off "${config_args[@]}" --sarif -o results.sarif >> semgrep-output.txt
