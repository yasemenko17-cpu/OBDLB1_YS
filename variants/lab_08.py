import copy

def schema_to_ddl(schema: dict) -> str:
    """
    Генерує DDL скрипт для PostgreSQL 18 на основі реляційної схеми.
    """
    sch = copy.deepcopy(schema)
    tables = sch.get("tables", {})
    
    create_statements = []
    alter_statements = []
    
    # 1. Генерація CREATE TABLE
    for t_name, t_info in tables.items():
        cols_def = []
        
        # Обробка стовпців
        for col in t_info.get("columns", []):
            c_name = col["name"]
            c_type = col["type"]
            nullable = col.get("nullable", True)
            identity = col.get("identity", False)
            
            col_str = f'"{c_name}" {c_type}'
            if identity:
                col_str += " GENERATED ALWAYS AS IDENTITY"
            if not nullable:
                col_str += " NOT NULL"
            cols_def.append(col_str)
            
        # Первинний ключ (PK)
        pk = t_info.get("pk", [])
        if pk:
            pk_cols = ", ".join([f'"{c}"' for c in pk])
            cols_def.append(f"PRIMARY KEY ({pk_cols})")
            
        # Унікальні обмеження (UNIQUE)
        for u_cols in t_info.get("unique", []):
            u_str = ", ".join([f'"{c}"' for c in u_cols])
            cols_def.append(f"UNIQUE ({u_str})")
            
        # Обмеження CHECK
        for chk in t_info.get("checks", []):
            cols_def.append(f"CHECK ({chk})")
            
        # Збираємо CREATE TABLE
        cols_joined = ",\n    ".join(cols_def)
        create_statements.append(f'CREATE TABLE "{t_name}" (\n    {cols_joined}\n);')
        
        # 2. Зовнішні ключі (виносимо в ALTER TABLE, щоб уникнути циклічних залежностей)
        for fk in t_info.get("fks", []):
            fk_cols = ", ".join([f'"{c}"' for c in fk["columns"]])
            ref_table = fk["ref_table"]
            ref_cols = ", ".join([f'"{c}"' for c in fk["ref_columns"]])
            on_delete = fk.get("on_delete", "NO ACTION")
            
            alter_sql = (
                f'ALTER TABLE "{t_name}" '
                f'ADD FOREIGN KEY ({fk_cols}) '
                f'REFERENCES "{ref_table}" ({ref_cols})'
            )
            if on_delete and on_delete != "NO ACTION":
                alter_sql += f" ON DELETE {on_delete}"
            alter_sql += ";"
            
            alter_statements.append(alter_sql)
            
    # Об'єднуємо всі команди в один скрипт
    all_sql = "\n".join(create_statements + alter_statements)
    return all_sql