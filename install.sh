#!/usr/bin/env bash
# Rails Frontend CLI - Tek Komutla Kurulum Scripti
# Kullanım: bash <(curl -fsSL https://raw.githubusercontent.com/ozbilgic/rails-frontend-cli/main/install.sh)

set -e

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Kurulum dizini
INSTALL_DIR="$HOME/.rails-frontend-cli"
REPO_URL="https://github.com/ozbilgic/rails-frontend-cli.git"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Rails Frontend CLI Kurulum${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Git kontrolü
if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ Git bulunamadı!${NC}"
    echo "Lütfen önce Git'i yükleyin: https://git-scm.com/"
    exit 1
fi

# Ruby kontrolü
if ! command -v ruby &> /dev/null; then
    echo -e "${RED}✗ Ruby bulunamadı!${NC}"
    echo "Lütfen önce Ruby'yi yükleyin: https://www.ruby-lang.org/"
    exit 1
fi

echo -e "${BLUE}[1/5]${NC} Gereksinimler kontrol ediliyor..."
echo -e "  ${GREEN}✓${NC} Git: $(git --version | head -n1)"
echo -e "  ${GREEN}✓${NC} Ruby: $(ruby --version)"
echo ""

# Eski kurulum kontrolü
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}⚠ Mevcut kurulum bulundu: $INSTALL_DIR${NC}"
    read -p "Mevcut kurulumu kaldırıp yeniden kurmak istiyor musunuz? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}[2/5]${NC} Eski kurulum kaldırılıyor..."
        rm -rf "$INSTALL_DIR"
        echo -e "  ${GREEN}✓${NC} Eski kurulum kaldırıldı"
    else
        echo -e "${RED}✗ Kurulum iptal edildi${NC}"
        exit 1
    fi
else
    echo -e "${BLUE}[2/5]${NC} Kurulum dizini hazırlanıyor..."
    echo -e "  ${GREEN}✓${NC} Kurulum dizini: $INSTALL_DIR"
fi
echo ""

# Repository klonla
echo -e "${BLUE}[3/5]${NC} Repository klonlanıyor..."
if git clone --quiet "$REPO_URL" "$INSTALL_DIR"; then
    echo -e "  ${GREEN}✓${NC} Repository klonlandı"
else
    echo -e "${RED}✗ Repository klonlanamadı!${NC}"
    exit 1
fi
echo ""

# Dosya izinlerini ayarla
echo -e "${BLUE}[4/5]${NC} Dosya izinleri ayarlanıyor..."
chmod +x "$INSTALL_DIR/rails-frontend"
chmod +x "$INSTALL_DIR/rails_frontend_setup.rb"
echo -e "  ${GREEN}✓${NC} İzinler ayarlandı"
echo ""

# Shell yapılandırması
echo -e "${BLUE}[5/5]${NC} Shell yapılandırması..."

# Shell tipini tespit et
SHELL_NAME=$(basename "$SHELL")
if [ "$SHELL_NAME" = "zsh" ]; then
    RC_FILE="$HOME/.zshrc"
elif [ "$SHELL_NAME" = "bash" ]; then
    RC_FILE="$HOME/.bashrc"
else
    RC_FILE="$HOME/.profile"
fi

# PATH'e eklenmiş mi kontrol et
PATH_ENTRY="export PATH=\"\$PATH:$INSTALL_DIR\""

if grep -q "rails-frontend-cli" "$RC_FILE" 2>/dev/null; then
    echo -e "  ${YELLOW}⚠${NC} PATH zaten yapılandırılmış"
else
    echo "" >> "$RC_FILE"
    echo "# Rails Frontend CLI" >> "$RC_FILE"
    echo "$PATH_ENTRY" >> "$RC_FILE"
    echo -e "  ${GREEN}✓${NC} PATH'e eklendi: $RC_FILE"
fi
echo ""

# Başarı mesajı
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✓ Kurulum başarıyla tamamlandı!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Sonraki adımlar:${NC}"
echo ""
echo -e "  1. Shell'i yeniden yükleyin:"
echo -e "     ${BLUE}source $RC_FILE${NC}"
echo ""
echo -e "  2. Kurulumu test edin:"
echo -e "     ${BLUE}rails-frontend --version${NC}"
echo ""
echo -e "  3. Yardım için:"
echo -e "     ${BLUE}rails-frontend help${NC}"
echo ""
echo -e "${YELLOW}Örnek kullanım:${NC}"
echo -e "  ${BLUE}rails-frontend new blog --clean${NC}"
echo ""
