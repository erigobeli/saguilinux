#!/bin/bash
# Fecha o H13 depois que o Eli confirmar o boot numa VM local e numa máquina real via pendrive.
# Uso: bash scripts/confirmar-hardware.sh "descrição do que foi testado e o resultado"
set -e
cd "$(dirname "$0")/.."
[ -n "${1:-}" ] || { echo "Uso: $0 \"descrição do teste (VM e máquina real)\""; exit 1; }
python3 scripts/status.py diario H13 "Teste em hardware confirmado pelo Eli: $1" "ok"
python3 scripts/status.py marco H13 feito
python3 scripts/status.py bloqueio ""
python3 scripts/status.py proximo "Fase 1 concluída. Fase 2 (BLFS: Xorg + XFCE) aguarda autorização."
sed -i "s|^- \*\*Validação em hardware (Eli):\*\*.*|- **Validação em hardware (Eli):** $1|" historias/H13.md
echo "H13 fechado. Dashboard: $(python3 -c "import json;print(json.load(open('status.json'))['porcentagem'])")%"
