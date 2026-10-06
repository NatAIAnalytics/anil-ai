import sqlite3
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(BASE_DIR, "empresa.db")
SQL_PATH = os.path.join(BASE_DIR, "seed_data.sql")

if os.path.exists(DB_PATH):
    os.remove(DB_PATH)

conn = sqlite3.connect(DB_PATH)
with open(SQL_PATH, encoding="utf-8") as f:
    conn.executescript(f.read())
conn.commit()
conn.close()

print(f"Base de datos creada correctamente en: {DB_PATH}")

