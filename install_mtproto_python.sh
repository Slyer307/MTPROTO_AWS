#!/bin/bash

set -e

echo "🚀 Cài đặt MTProto Proxy (bản Python - ổn định)"

# 1. Cài các gói cần thiết
echo "📦 Cài đặt gói hệ thống..."
apt update -y
apt install -y git python3 python3-pip curl screen

# 2. Clone repo chính thức
echo "📥 Tải mã nguồn từ alexbers..."
rm -rf /opt/mtprotoproxy
git clone https://github.com/alexbers/mtprotoproxy /opt/mtprotoproxy

# 3. Cài dependencies Python
echo "🐍 Cài đặt Python packages..."
pip3 install -r /opt/mtprotoproxy/requirements.txt

# 4. Sinh secret ngẫu nhiên
SECRET=$(openssl rand -hex 16)
echo "🔑 Secret đã tạo: $SECRET"

# 5. Tạo config.py
echo "🛠️ Tạo cấu hình proxy..."
cat <<EOF > /opt/mtprotoproxy/config.py
PORT = 443
USERS = {
    "$SECRET": "default"
}
MODES = {
    "classic": True
}
EOF

# 6. Tạo systemd service
echo "🔧 Tạo systemd service..."
cat <<EOF > /etc/systemd/system/mtproto.service
[Unit]
Description=MTProto Proxy Python Service
After=network.target

[Service]
WorkingDirectory=/opt/mtprotoproxy
ExecStart=/usr/bin/python3 /opt/mtprotoproxy/mtprotoproxy.py
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# 7. Kích hoạt dịch vụ
systemctl daemon-reload
systemctl enable mtproto
systemctl restart mtproto

# 8. Mở port firewall
echo "🔓 Mở cổng 443 nếu cần..."
ufw allow 443/tcp || true
iptables -I INPUT -p tcp --dport 443 -j ACCEPT || true

# 9. Hiển thị link
IP=$(curl -s https://api.ipify.org)
echo ""
echo "✅ Proxy đã cài thành công!"
echo "🔗 Link Telegram:"
echo "tg://proxy?server=$IP&port=443&secret=dd$SECRET"
echo ""
