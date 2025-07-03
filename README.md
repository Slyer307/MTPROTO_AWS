# MTProto Proxy Installer (2 phiên bản)

Script hỗ trợ cài đặt MTProto Proxy cho Telegram trên VPS Ubuntu với 2 tùy chọn:

---

## 🚀 1. Bản **C++ (tối ưu tốc độ)**

Cài đặt bản được build từ `krepver/MTProxy`, tối ưu tốc độ, nhưng dễ crash trên một số hệ thống.

### ▶️ Cài đặt:

```bash
curl -LO https://raw.githubusercontent.com/Slyer307/mtproto-telegram-aws/main/MTProtoProxyOfficialInstall_OPTIMIZED.sh
chmod +x MTProtoProxyOfficialInstall_OPTIMIZED.sh
sudo ./MTProtoProxyOfficialInstall_OPTIMIZED.sh
```

---

## 🧩 2. Bản **Python (ổn định tuyệt đối)**

Sử dụng mã nguồn từ `alexbers/mtprotoproxy`, cực kỳ ổn định, dễ bảo trì, không crash.

### ▶️ Cài đặt:

```bash
curl -LO https://raw.githubusercontent.com/Slyer307/mtproto-telegram-aws/main/install_mtproto_python.sh
chmod +x install_mtproto_python.sh
sudo ./install_mtproto_python.sh
```

---

## 📲 Sau khi cài đặt thành công

Bạn sẽ thấy một đường dẫn dạng:

```
tg://proxy?server=<your-ip>&port=443&secret=dd<your-secret>
```

👉 Hãy copy và dán vào Telegram để sử dụng proxy.

---

## 🔒 Lưu ý bảo mật & kết nối

- Hãy đảm bảo cổng TCP `443` đã được mở trong AWS Security Group hoặc firewall (UFW)
- Nếu Telegram không thể kết nối:
  - Kiểm tra secret đúng 32 ký tự hex
  - Đảm bảo không bị ISP/AWS chặn port
  - Xem log: `journalctl -u MTProxy -n 50`
- Nếu thiếu `xxd`, bạn có thể cài bằng:
  ```bash
  sudo apt update
  sudo apt install xxd -y
  ```

---

## 💡 Gợi ý nâng cao

- Bạn có thể chạy script trong screen hoặc tmux để tránh gián đoạn
- Bản Python có thể dễ dàng tùy biến `config.py` để thêm người dùng, thay đổi cổng

---

**Nguồn gốc mã nguồn:**
- C++: [https://github.com/krepver/MTProxy](https://github.com/krepver/MTProxy)
- Python: [https://github.com/alexbers/mtprotoproxy](https://github.com/alexbers/mtprotoproxy)
