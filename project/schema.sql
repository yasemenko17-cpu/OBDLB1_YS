CREATE TABLE "customer" (
    "id" integer GENERATED ALWAYS AS IDENTITY,
    "email" text NOT NULL,
    "phone" text NOT NULL,
    "address_city" text NOT NULL,
    "address_street" text NOT NULL,
    PRIMARY KEY ("id"),
    UNIQUE ("email")
);

CREATE TABLE "customer_alt_phones" (
    "customer_id" integer NOT NULL,
    "value" text NOT NULL,
    PRIMARY KEY ("customer_id", "value"),
    FOREIGN KEY ("customer_id") REFERENCES "customer" ("id") ON DELETE CASCADE
);

CREATE TABLE "category" (
    "id" integer GENERATED ALWAYS AS IDENTITY,
    "title" text NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "product" (
    "id" integer GENERATED ALWAYS AS IDENTITY,
    "name" text NOT NULL,
    "price" numeric(12,2) NOT NULL,
    "category_id" integer NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("category_id") REFERENCES "category" ("id") ON DELETE RESTRICT
);

CREATE TABLE "orders" (
    "id" integer GENERATED ALWAYS AS IDENTITY,
    "order_date" date NOT NULL,
    "status" text NOT NULL,
    "customer_id" integer NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("customer_id") REFERENCES "customer" ("id") ON DELETE RESTRICT
);

CREATE TABLE "order_item" (
    "orders_id" integer NOT NULL,
    "item_no" integer NOT NULL,
    "quantity" integer NOT NULL,
    "product_id" integer NOT NULL,
    PRIMARY KEY ("orders_id", "item_no"),
    FOREIGN KEY ("orders_id") REFERENCES "orders" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE RESTRICT
);

CREATE TABLE "warehouse" (
    "id" integer GENERATED ALWAYS AS IDENTITY,
    "location" text NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "stock" (
    "warehouse_id" integer NOT NULL,
    "stock_id" integer NOT NULL,
    "quantity" integer NOT NULL,
    "product_id" integer NOT NULL,
    PRIMARY KEY ("warehouse_id", "stock_id"),
    FOREIGN KEY ("warehouse_id") REFERENCES "warehouse" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE RESTRICT
);
```[cite: 11, 12, 21, 22]

3. Збережіть файл `schema.sql`.
4. Перевірте, чи успішно таблиці створюються в базі даних PostgreSQL, виконавши в терміналі[cite: 22]:
   ```bash
   python project_check/load_schema.py
   ```[cite: 22]

Скажіть, коли виконаєте це, і ми перейдемо до генерації словника даних та комітів у Git!