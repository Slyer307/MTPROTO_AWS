
# MTProto Proxy Installer (Optimized)

Script cài đặt MTProto Proxy chính thức cho Telegram trên VPS Ubuntu.

## 🚀 Cách sử dụng

```bash
curl -LO https://raw.githubusercontent.com/Slyer307/mtproto-telegram-aws/main/MTProtoProxyOfficialInstall_OPTIMIZED.sh
chmod +x MTProtoProxyOfficialInstall_OPTIMIZED.sh
sudo ./MTProtoProxyOfficialInstall_OPTIMIZED.sh
```

## ✅ Tính năng đã được tối ưu:

- Tự động xóa thư mục cũ `/opt/MTProxy` để tránh lỗi khi cài lại
- Sử dụng Fake-TLS domain mặc định là `www.bing.com` (an toàn hơn)
- Thêm kiểm tra các file cấu hình `proxy-secret` và `proxy-multi.conf`
- Tự động tạo systemd để MTProto proxy chạy ngầm (dù SSH bị ngắt)
- Hỗ trợ NAT, tường lửa, cập nhật tag định kỳ

## 📲 Sau khi cài đặt xong

Bạn sẽ thấy đường dẫn dạng:

```
tg://proxy?server=<your-ip>&port=443&secret=dd<your-secret>
```

Hãy dán link này vào Telegram để kết nối.

## 🧠 Ghi chú thêm

- Đảm bảo mở cổng TCP 443 trong AWS Security Group hoặc firewall
- Nếu Telegram không thể kết nối: kiểm tra lại secret, port, hoặc dùng Cloudflare tunnel thay thế

---

**Nguồn gốc mã nguồn:** [https://github.com/krepver/MTProxy](https://github.com/krepver/MTProxy)
