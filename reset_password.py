"""Chạy script này trên VPS để reset password: python3 reset_password.py"""
import yaml, bcrypt, getpass
from pathlib import Path

AUTH_CONFIG = Path.home() / ".bds_scraper" / "auth_config.yaml"

if not AUTH_CONFIG.exists():
    print("Chưa có user nào. Chạy create_user.py trước.")
    exit()

with open(AUTH_CONFIG) as f:
    config = yaml.safe_load(f)

users = config["credentials"]["usernames"]
print("=== Danh sách user ===")
for i, (u, info) in enumerate(users.items(), 1):
    print(f"  {i}. {u} — {info['name']}")

username = input("\nNhập username cần reset: ").strip()
if username not in users:
    print(f"Không tìm thấy user '{username}'")
    exit()

new_password = getpass.getpass("Password mới: ")
hashed = bcrypt.hashpw(new_password.encode(), bcrypt.gensalt()).decode()
config["credentials"]["usernames"][username]["password"] = hashed

with open(AUTH_CONFIG, "w") as f:
    yaml.dump(config, f, allow_unicode=True)

print(f"✓ Đã reset password cho '{username}'")
