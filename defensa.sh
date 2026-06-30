#!/bin/bash

set -euo pipefail

echo "======================================"
echo " DEFENSA DEL SERVIDOR WEB"
echo "======================================"

# Verificar permisos
if [[ $EUID -ne 0 ]]; then
    echo "[ERROR] Este script debe ejecutarse como root."
    exit 1
fi

echo "[1/4] Limpiando reglas actuales..."
iptables -F

echo "[2/4] Aplicando protección contra SYN Flood..."

# Permitir hasta 10 conexiones SYN por segundo
iptables -A INPUT -p tcp --syn --dport 80 \
-m limit --limit 10/second --limit-burst 20 \
-j ACCEPT

# Bloquear el exceso
iptables -A INPUT -p tcp --syn --dport 80 -j DROP

echo "[3/4] Bloqueando solicitudes hacia db.sql..."

iptables -A INPUT -p tcp --dport 80 \
-m string \
--string "db.sql" \
--algo bm \
-j DROP

echo "[4/4] Reglas aplicadas correctamente."

echo
iptables -L INPUT -n --line-numbers

echo
echo "Mitigación completada." 
