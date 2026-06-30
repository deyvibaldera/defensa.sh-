#!/bin/bash

set -euo pipefail

echo "======================================"
echo " RESTAURANDO EL LABORATORIO"
echo "======================================"

# Verificar permisos
if [[ $EUID -ne 0 ]]; then
    echo "[ERROR] Este script debe ejecutarse como root."
    exit 1
fi

echo "[1/2] Eliminando reglas del firewall..."

iptables -F

echo "[2/2] Verificando reglas..."

iptables -L INPUT -n --line-numbers

echo
echo "Laboratorio restaurado correctamente." 
