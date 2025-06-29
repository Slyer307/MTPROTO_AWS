#!/bin/bash

# Dừng script nếu có lỗi
set -e

echo "🔁 Đang chuyển SOCKS5 proxy từ port 443 sang 1080..."

# Tìm file cấu hình của dante (thường nằm tại /etc/danted.conf)
CONF_FILE="/etc/danted.conf"
BACKUP_FILE="/etc/danted.conf.bak"

if [ ! -f "$CONF_FILE" ]; then
  echo "❌ Không tìm thấy file cấu hình Dante tại $CONF_FILE"
  exit 1
fi

# Sao lưu cấu hình gốc
cp "$CONF_FILE" "$BACKUP_FILE"
echo "🗂 Đã sao lưu cấu hình gốc tại $BACKUP_FILE"

# Thay thế port trong cấu hình (giả sử có dòng như: internal: eth0 port = 443)
sed -i 's/port = 443/port = 1080/g' "$CONF_FILE"

# Hoặc nếu cấu hình dùng kiểu: internal: eth0 port 443
sed -i 's/port 443/port 1080/g' "$CONF_FILE"

# Khởi động lại dịch vụ Dante
echo "♻️ Khởi động lại dịch vụ Dante..."
systemctl restart danted

# Kiểm tra lại trạng thái
echo "📡 Trạng thái SOCKS5 mới:"
ss -tuln | grep 1080 || echo "⚠️ Không thấy proxy đang chạy trên cổng 1080"

echo ""
echo "✅ SOCKS5 proxy đã được chuyển sang cổng 1080 thành công!"
