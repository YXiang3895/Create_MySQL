import mysql.connector
from mysql.connector import Error
import json

def get_config(config_file):
    """讀取配置檔"""
    try:
        with open(config_file, 'r') as file:
            return json.load(file)
    except FileNotFoundError:
        print(f"設定檔 {config_file} 未找到")
        return None
    except json.JSONDecodeError:
        print("設定檔解析錯誤")
        return None

def create_database(connection, database_name):
    """創建資料庫"""
    try:
        cursor = connection.cursor()
        cursor.execute(f"CREATE DATABASE IF NOT EXISTS {database_name}")
        print(f"資料庫 '{database_name}' 創建成功！")
    except Error as e:
        print(f"錯誤: {e}")

def create_table(connection, table_name, columns):
    """創建表格"""
    cursor = connection.cursor()

    # 構建 CREATE TABLE 語句
    column_definitions = ", ".join([f"{col['name']} {col['type']} {col['options']}" for col in columns])
    create_table_query = f"CREATE TABLE IF NOT EXISTS {table_name} ({column_definitions})"
    
    try:
        cursor.execute(create_table_query)
        print(f"表格 '{table_name}' 創建成功！")
    except Error as e:
        print(f"錯誤: {e}")

def main():
    config_file = 'config.json'
    config = get_config(config_file)
    
    if not config:
        return

    database_name = config.get("database_name")
    if not database_name:
        print("配置檔中未找到資料庫名稱")
        return

    try:
        # 連接到 MySQL 伺服器（無需指定資料庫）
        connection = mysql.connector.connect(
            host='localhost',  # MySQL 伺服器的主機名稱
            user='root',       # MySQL 的用戶名稱
            password='your_password'  # MySQL 的密碼
        )

        if connection.is_connected():
            create_database(connection, database_name)  # 創建資料庫
            connection.database = database_name  # 切換到創建的資料庫
            
            # 根據配置創建表格
            for table in config['tables']:
                create_table(connection, table['name'], table['columns'])

    except Error as e:
        print(f"錯誤: {e}")
    finally:
        if connection.is_connected():
            connection.close()

if __name__ == "__main__":
    main()
