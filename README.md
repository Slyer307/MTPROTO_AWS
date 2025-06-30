
# MTProto Proxy - Triển khai nhanh trên Ubuntu VPS

## ✅ Cách cài đặt lại proxy:

```bash
curl -L -o install_mtproto.sh https://raw.githubusercontent.com/Slyer307/mtproto-telegram-aws/main/MTProtoProxyOfficialInstall.sh
chmod +x install_mtproto.sh
sudo ./install_mtproto.sh
```

> ⚠️ Script sẽ sử dụng port mặc định 443 nếu không sửa.

## ✅ Tạo link Telegram:

Sau khi script chạy xong, bạn sẽ thấy secret được tạo.  
Tạo link như sau:

```
tg://proxy?server=<your-ip>&port=443&secret=dd<your_secret>
```

## ✅ Kiểm tra dịch vụ:

```bash
sudo systemctl status MTProxy
```

## ✅ Mở firewall (nếu cần):

```bash
sudo ufw allow 443/tcp
sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT
```

## 📌 Ghi chú:
- Dịch vụ sẽ tự khởi động lại khi reboot
- Bạn có thể chỉnh sửa lại cấu hình bằng cách chỉnh file `MTProxy.service`
