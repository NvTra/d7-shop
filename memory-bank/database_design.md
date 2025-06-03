# Database Design Documentation

## Overview
D7-Shop sử dụng PostgreSQL làm hệ quản trị cơ sở dữ liệu chính. Thiết kế database tuân thủ các nguyên tắc:
- Sử dụng UUID làm primary key cho tất cả các bảng
- Tích hợp audit fields (created_at, created_by, updated_at, updated_by)
- Hỗ trợ soft delete với deleted_at và is_deleted
- Sử dụng các constraint để đảm bảo tính toàn vẹn dữ liệu
- Đánh index cho các trường thường xuyên tìm kiếm

## Common Fields
Tất cả các bảng đều có các trường sau:
```sql
id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
created_by VARCHAR(255)
updated_at TIMESTAMP
updated_by VARCHAR(255)
deleted_at TIMESTAMP
is_deleted BOOLEAN NOT NULL DEFAULT FALSE
```

## Tables

### users
```sql
username VARCHAR(50) NOT NULL
email VARCHAR(100) NOT NULL
password_hash VARCHAR(255) NOT NULL
role VARCHAR(20) NOT NULL
```
Indexes:
- `idx_users_email` WHERE deleted_at IS NULL
- `idx_users_username` WHERE deleted_at IS NULL

Constraints:
- `uk_users_email` UNIQUE NULLS NOT DISTINCT (email) WHERE deleted_at IS NULL
- `uk_users_username` UNIQUE NULLS NOT DISTINCT (username) WHERE deleted_at IS NULL

### categories
```sql
name VARCHAR(100) NOT NULL
description TEXT
```
Indexes:
- `idx_categories_name` WHERE deleted_at IS NULL

Constraints:
- `uk_categories_name` UNIQUE NULLS NOT DISTINCT (name) WHERE deleted_at IS NULL

### products
```sql
name VARCHAR(200) NOT NULL
description TEXT
sku VARCHAR(50) NOT NULL
price DECIMAL(10,2) NOT NULL
sale_price DECIMAL(10,2)
quantity INTEGER NOT NULL
category_id UUID REFERENCES categories(id)
```
Indexes:
- `idx_products_name` WHERE deleted_at IS NULL
- `idx_products_sku` WHERE deleted_at IS NULL
- `idx_products_category_id` WHERE deleted_at IS NULL

Constraints:
- `uk_products_sku` UNIQUE NULLS NOT DISTINCT (sku) WHERE deleted_at IS NULL
- `chk_products_price` CHECK (price >= 0)
- `chk_products_sale_price` CHECK (sale_price >= 0 AND sale_price <= price)
- `chk_products_quantity` CHECK (quantity >= 0)

### product_images
```sql
product_id UUID REFERENCES products(id)
image_url VARCHAR(255) NOT NULL
is_primary BOOLEAN NOT NULL DEFAULT FALSE
```

### product_reviews
```sql
product_id UUID REFERENCES products(id)
user_id UUID REFERENCES users(id)
user_name VARCHAR(50) NOT NULL
rating INTEGER NOT NULL
comment TEXT
status VARCHAR(20) NOT NULL
```
Indexes:
- `idx_product_reviews_product_id` WHERE deleted_at IS NULL
- `idx_product_reviews_user_id` WHERE deleted_at IS NULL

Constraints:
- `chk_product_reviews_rating` CHECK (rating >= 1 AND rating <= 5)

Triggers:
- `trg_update_review_user_name`: Tự động cập nhật user_name từ users

### carts
```sql
user_id UUID REFERENCES users(id)
total_amount DECIMAL(10,2) NOT NULL DEFAULT 0
total_items INTEGER NOT NULL DEFAULT 0
```

### cart_items
```sql
cart_id UUID REFERENCES carts(id)
product_id UUID REFERENCES products(id)
quantity INTEGER NOT NULL
price DECIMAL(10,2) NOT NULL
```
Indexes:
- `idx_cart_items_cart_id` WHERE deleted_at IS NULL
- `idx_cart_items_product_id` WHERE deleted_at IS NULL

Constraints:
- `chk_cart_items_quantity` CHECK (quantity >= 0)
- `chk_cart_items_price` CHECK (price >= 0)

### orders
```sql
user_id UUID REFERENCES users(id)
total_amount DECIMAL(10,2) NOT NULL
status VARCHAR(20) NOT NULL
shipping_address TEXT NOT NULL
```

### order_items
```sql
order_id UUID REFERENCES orders(id)
product_id UUID REFERENCES products(id)
quantity INTEGER NOT NULL
price DECIMAL(10,2) NOT NULL
```
Indexes:
- `idx_order_items_order_id` WHERE deleted_at IS NULL
- `idx_order_items_product_id` WHERE deleted_at IS NULL

Constraints:
- `chk_order_items_quantity` CHECK (quantity >= 0)
- `chk_order_items_price` CHECK (price >= 0)

### payments
```sql
order_id UUID REFERENCES orders(id)
amount DECIMAL(10,2) NOT NULL
status VARCHAR(20) NOT NULL
payment_method VARCHAR(50) NOT NULL
transaction_id VARCHAR(100)
```

## Migration History

1. V1__Create_Base_Tables.sql
   - Tạo bảng users
   - Tạo bảng categories
   - Tạo bảng user_addresses

2. V2__Create_Product_Tables.sql
   - Tạo bảng products
   - Tạo bảng product_images
   - Tạo bảng product_reviews

3. V3__Create_Order_Tables.sql
   - Tạo bảng carts
   - Tạo bảng cart_items
   - Tạo bảng orders
   - Tạo bảng order_items
   - Tạo bảng payments

4. V4__Add_Sample_Data.sql
   - Thêm dữ liệu mẫu cho tất cả các bảng

5. V5__Add_Constraints.sql
   - Thêm CHECK constraints cho các trường số
   - Thêm UNIQUE constraints với NULLS NOT DISTINCT
   - Thêm các index có điều kiện
   - Thêm trigger tự động cập nhật user_name 