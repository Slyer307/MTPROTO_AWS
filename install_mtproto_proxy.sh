#!/bin/bash

# Tự động dừng nếu có lỗi
set -e

echo "==============================="
echo "🔥 Cài đặt MTProto Proxy cho Telegram trên Ubuntu"
echo "==============================="

# Hỏi port
read -p "👉 Nhập port bạn muốn dùng cho proxy (vd: 443, 8443, 10000): " PORT
if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
    echo "❌ Port không hợp lệ"
    exit 1
fi

# Cài đặt gói cần thiết
echo "📦 Cài đặt gói cần thiết..."
apt update && apt install -y git curl python3-pip python3-dev libssl-dev zlib1g-dev screen

# Cài đặt MTProtoProxy
echo "🚀 Tải mã nguồn MTProto Proxy..."
cd /opt
git clone https://github.com/alexbers/mtprotoproxy.git
cd mtprotoproxy

echo "📦 Cài Python packages..."
pip3 install -r requirements.txt

# Tạo secret
SECRET=$(openssl rand -hex 16)
echo "🔑 SECRET được tạo: $SECRET"

# Cấu hình
cat <<EOF > config.py
PORT = $PORT
USERS = {
    "$SECRET": "default"
}
MODES = {
    "classic": True
}
EOF

# Tạo systemd service
echo "🛠 Tạo service để chạy ngầm..."
cat <<EOF > /etc/systemd/system/mtproto.service
[Unit]
Description=MTProto Proxy Service
After=network.target

[Service]
WorkingDirectory=/opt/mtprotoproxy
ExecStart=/usr/bin/python3 /opt/mtprotoproxy/mtprotoproxy.py
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Bật service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable mtproto
systemctl start mtproto

# Mở port firewall
echo "🔓 Mở port $PORT trên firewall..."
ufw allow $PORT/tcp || true
iptables -I INPUT -p tcp --dport $PORT -j ACCEPT

# Tối ưu hệ thống (BBR + sysctl)
echo "⚙️ Tối ưu hệ thống..."
cat <<EOF >> /etc/sysctl.conf

# TCP Optimizations
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_tw_reuse=1
EOF

sysctl -p

# Xuất link proxy
IP=$(curl -s https://api.ipify.org)
echo ""
echo "✅ MTProto Proxy đã cài thành công!"
echo "🔗 Link: tg://proxy?server=$IP&port=$PORT&secret=dd$SECRET"
echo ""
