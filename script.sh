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
    if find . -type f -name "${ext}" >/dev/null 2>&1; then
        config_args+=("--config" "semgrep-rules/${MAP[$ext]}")
    fi
done

if [ "${#config_args[@]}" -eq 0 ]; then
    echo "No matching files found for semgrep scan."
    exit 1
fi

#semgrep ci --config semgrep-rules/python --sarif -o results.sarif >> semgrep-output.txt
semgrep ci "${config_args[@]}" --metrics=off  --sarif > results.sarif || true
