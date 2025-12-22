#!/usr/bin/env bash
# Rails Frontend CLI Kurulum Scripti

set -e

echo "Rails Frontend CLI Kurulum Başlıyor..."
echo ""

# Mevcut dizini al
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Executable dosyalara izin ver
echo "Dosya izinleri ayarlanıyor..."
chmod +x "$SCRIPT_DIR/rails-frontend"
chmod +x "$SCRIPT_DIR/rails_frontend_setup.rb"

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
if grep -q "rails_frontend_cli" "$RC_FILE" 2>/dev/null; then
    echo "PATH zaten yapılandırılmış"
else
    echo "PATH'e ekleniyor..."
    echo "" >> "$RC_FILE"
    echo "# Rails Frontend CLI" >> "$RC_FILE"
    echo "export PATH=\"\$PATH:$SCRIPT_DIR\"" >> "$RC_FILE"
    echo "PATH'e eklendi: $RC_FILE"
fi

echo ""
echo "Kurulum tamamlandı!"
echo ""
echo "Değişiklikleri aktif etmek için:"
echo "   source $RC_FILE"
echo ""
echo "Kullanım:"
echo "   rails-frontend help"
echo "   rails-frontend new proje_adi"
echo ""
