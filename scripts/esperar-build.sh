#!/bin/bash
# Loop de monitoramento: espera (sem ler a saída do make) até logs/estado-build virar OK/FAIL.
f=$(dirname "$0")/../logs/estado-build
while ! grep -qE '^(OK|FAIL)' "$f" 2>/dev/null; do sleep ${1:-60}; done
cat "$f"
