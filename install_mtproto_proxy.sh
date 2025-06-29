#!/bin/bash

set -e

echo "==============================="
echo "🚀 Cài đặt MTProto Proxy cho Telegram (Ubuntu + VENV)"
echo "==============================="

read -p "👉 Nhập cổng bạn muốn dùng cho MTProto Proxy (vd: 443): " PORT
if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
    echo "❌ Port không hợp lệ!"
    exit 1
fi

echo "📦 Cài các gói cần thiết..."
apt update
apt i
