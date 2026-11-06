#!/bin/bash

set -o pipefail

ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[0;34m'
NC='\033[0m'

echo -e "${AZUL}"
echo "======================================"
echo "  COMONFORT DEPLOY TOOL"
echo "======================================"
echo -e "${NC}"

error() {
    echo -e "${ROJO}[ERROR] $1${NC}"
    exit 1
}

ok() {
    echo -e "${VERDE}[OK] $1${NC}"
}

info() {
    echo -e "${AMARILLO}[INFO] $1${NC}"
}

# Verificar Git
command -v git >/dev/null 2>&1 || error "Git no esta instalado."

# Verificar repositorio
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || \
error "No estas dentro de un repositorio Git."

# Verificar remoto
git remote get-url origin >/dev/null 2>&1 || \
error "No existe el remoto origin."

# Verificar conexión GitHub
info "Verificando acceso a GitHub..."

git ls-remote origin >/dev/null 2>&1

if [ $? -ne 0 ]; then
    error "No fue posible conectar con GitHub."
fi

ok "Conexion con GitHub correcta"

# Verificar cambios
if git diff --quiet && git diff --cached --quiet; then

    if [ -z "$(git ls-files --others --exclude-standard)" ]; then
        info "No hay cambios para subir."
        exit 0
    fi

fi

info "Agregando archivos..."

git add . || error "Fallo git add"

ok "Archivos agregados"

MENSAJE="${1:-Actualizacion $(date '+%Y-%m-%d %H:%M:%S')}"

info "Creando commit..."

git commit -m "$MENSAJE"

COMMIT_EXIT=$?

if [ $COMMIT_EXIT -ne 0 ]; then

    if git diff --cached --quiet; then
        info "No hubo cambios que confirmar."
        exit 0
    fi

    error "Fallo git commit."
fi

ok "Commit realizado"

info "Subiendo a GitHub..."

git push origin main

PUSH_EXIT=$?

if [ $PUSH_EXIT -ne 0 ]; then
    error "Fallo git push."
fi

ok "Push realizado correctamente"

echo
echo -e "${VERDE}======================================"
echo " DEPLOY FINALIZADO CORRECTAMENTE "
echo "======================================"
echo -e "${NC}"
