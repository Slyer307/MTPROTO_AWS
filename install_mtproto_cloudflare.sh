#!/bin/bash
set -e

echo "🚀 Cài đặt MTProto + Cloudflare Tunnel (bypass chặn ISP VN)"

# Cài gói cần thiết
apt update
apt install -y python3-venv python3-pip git curl

# Tạo venv và clone proxy
rm -rf /opt/mtprotoproxy /opt/mtprotoenv
git clone https://github.com/alexbers/mtprotoproxy.git /opt/mtprotoproxy
python3 -m venv /opt/mtprotoenv
/opt/mtprotoenv/bin/pip install --upgrade pip
/opt/mtprotoenv/bin/pip install -r /opt/mtprotoproxy/requirements.txt

# Tạo SECRET
SECRET=$(openssl rand -hex 16)

# Ghi config
cat <<EOF > /opt/mtprotoproxy/config.py
PORT = 8443
USERS = {
    "telegram": "$SECRET"
}
MODES = {
    "classic": True
}
EOF

# Tạo service
cat <<EOF > /etc/systemd/system/mtproto.service
[Unit]
Description=MTProto Proxy
After=network.target

[Service]
WorkingDirectory=/opt/mtprotoproxy
ExecStart=/opt/mtprotoenv/bin/python3 /opt/mtprotoproxy/mtprotoproxy.py
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable mtproto
systemctl restart mtproto

# Cài cloudflared
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
dpkg -i cloudflared-linux-amd64.deb

# Tạo tunnel
echo "🌐 Đang khởi tạo tunnel Cloudflare..."
CF_DOMAIN=$(cloudflared tunnel --url http://localhost:8443 2>&1 | grep -o 'https://.*\.trycloudflare.com')

# Xuất link Telegram
SECRET_LINK="tg://proxy?server=$(echo $CF_DOMAIN | cut -d/ -f3)&port=443&secret=dd$SECRET"

echo ""
echo "✅ Proxy đã hoạt động qua Cloudflare!"
echo "🔗 Dán vào Telegram:"
echo "$SECRET_LINK"
echo ""
