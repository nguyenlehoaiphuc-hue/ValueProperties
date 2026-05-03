"""Chạy script này trên VPS để tạo/thêm user: python3 create_user.py"""
import yaml, bcrypt, getpass
from pathlib import Path

AUTH_CONFIG = Path.home() / ".bds_scraper" / "auth_config.yaml"
AUTH_CONFIG.parent.mkdir(parents=True, exist_ok=True)

# Load config hiện tại hoặc tạo mới
if AUTH_CONFIG.exists():
    with open(AUTH_CONFIG) as f:
        config = yaml.safe_load(f)
else:
    config = {
        "credentials": {"usernames": {}},
        "cookie": {"name": "bds_auth", "key": "bds_secret_key_2024", "expiry_days": 30}
    }

# Nhập thông tin user mới
print("=== Tạo user mới ===")
username = input("Username: ").strip()
name     = input("Họ tên: ").strip()
password = getpass.getpass("Password: ")

hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()
config["credentials"]["usernames"][username] = {
    "name": name,
    "password": hashed,
    "email": ""
}

with open(AUTH_CONFIG, "w") as f:
    yaml.dump(config, f, allow_unicode=True)

print(f"✓ Đã tạo user '{username}' thành công!")
print(f"Config lưu tại: {AUTH_CONFIG}")
