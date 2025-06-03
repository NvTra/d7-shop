# Database Design Documentation

## Overview
D7-Shop sử dụng PostgreSQL làm hệ quản trị cơ sở dữ liệu chính. Thiết kế database tuân thủ các nguyên tắc:
- Sử dụng UUID làm primary key cho tất cả các bảng
- Tích hợp audit fields (created_at, created_by, updated_at, updated_by)
- Hỗ trợ soft delete với deleted_at và is_deleted
- Sử dụng các constraint để đảm bảo tính toàn vẹn dữ liệu
- Đánh index cho các trường thường xuyên tìm kiếm
- Unique constraints với NULLS NOT DISTINCT cho soft delete
- Check constraints cho các trường số
- Foreign key với ON DELETE RESTRICT/CASCADE phù hợp

## Common Fields (BaseEntity)
Tất cả các bảng đều kế thừa từ BaseEntity với các trường sau:
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
password VARCHAR(255) NOT NULL
full_name VARCHAR(100) NOT NULL
phone VARCHAR(20)
role VARCHAR(20) NOT NULL DEFAULT 'USER'
status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
```
Indexes:
- `idx_users_email` WHERE deleted_at IS NULL
- `idx_users_username` WHERE deleted_at IS NULL
- `idx_users_role` WHERE deleted_at IS NULL
- `idx_users_status` WHERE deleted_at IS NULL

Constraints:
- `unique_username_not_deleted` UNIQUE NULLS NOT DISTINCT (username, deleted_at)
- `unique_email_not_deleted` UNIQUE NULLS NOT DISTINCT (email, deleted_at)

### categories
```sql
name VARCHAR(100) NOT NULL
slug VARCHAR(100) NOT NULL
description TEXT
image_url VARCHAR(255)
parent_id UUID REFERENCES categories(id) ON DELETE SET NULL
status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
display_order INT NOT NULL DEFAULT 0
```
Indexes:
- `idx_categories_parent_id` WHERE deleted_at IS NULL
- `idx_categories_slug` WHERE deleted_at IS NULL
- `idx_categories_status` WHERE deleted_at IS NULL
- `idx_categories_display_order` WHERE deleted_at IS NULL

Constraints:
- `unique_category_slug_not_deleted` UNIQUE NULLS NOT DISTINCT (slug, deleted_at)

### user_addresses
```sql
user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
recipient_name VARCHAR(100) NOT NULL
phone VARCHAR(20) NOT NULL
address_line1 VARCHAR(255) NOT NULL
address_line2 VARCHAR(255)
city VARCHAR(100) NOT NULL
state VARCHAR(100)
postal_code VARCHAR(20)
country VARCHAR(100) NOT NULL DEFAULT 'Vietnam'
is_default BOOLEAN NOT NULL DEFAULT FALSE
```
Indexes:
- `idx_user_addresses_user_id` WHERE deleted_at IS NULL
- `idx_user_addresses_is_default` WHERE deleted_at IS NULL AND is_default = true

### products
```sql
name VARCHAR(255) NOT NULL
slug VARCHAR(255) NOT NULL
description TEXT
category_id UUID NOT NULL REFERENCES categories(id) ON DELETE RESTRICT
price DECIMAL(15,2) NOT NULL CHECK (price >= 0)
sale_price DECIMAL(15,2) CHECK (sale_price >= 0 AND (sale_price IS NULL OR sale_price <= price))
stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0)
sku VARCHAR(50)
status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
enabled BOOLEAN NOT NULL DEFAULT TRUE
featured BOOLEAN NOT NULL DEFAULT FALSE
average_rating DOUBLE PRECISION
review_count INT NOT NULL DEFAULT 0
```
Indexes:
- `idx_products_category_id` WHERE deleted_at IS NULL
- `idx_products_slug` WHERE deleted_at IS NULL
- `idx_products_sku` WHERE deleted_at IS NULL
- `idx_products_status` WHERE deleted_at IS NULL
- `idx_products_enabled` WHERE deleted_at IS NULL
- `idx_products_featured` WHERE deleted_at IS NULL AND enabled = TRUE

Constraints:
- `unique_product_slug_not_deleted` UNIQUE NULLS NOT DISTINCT (slug, deleted_at)
- `unique_product_sku_not_deleted` UNIQUE NULLS NOT DISTINCT (sku, deleted_at)

### product_images
```sql
product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE
image_url VARCHAR(255) NOT NULL
is_primary BOOLEAN NOT NULL DEFAULT FALSE
display_order INT NOT NULL DEFAULT 0
```
Indexes:
- `idx_product_images_product_id` WHERE deleted_at IS NULL
- `idx_product_images_is_primary` WHERE deleted_at IS NULL
- `idx_product_images_display_order` WHERE deleted_at IS NULL

### product_reviews
```sql
product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE
user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
user_name VARCHAR(100) NOT NULL
rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5)
comment TEXT
status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
```
Indexes:
- `idx_product_reviews_product_id` WHERE deleted_at IS NULL
- `idx_product_reviews_user_id` WHERE deleted_at IS NULL
- `idx_product_reviews_rating` WHERE deleted_at IS NULL
- `idx_product_reviews_status` WHERE deleted_at IS NULL

Triggers:
- `tr_update_review_user_name`: Tự động cập nhật user_name từ users.full_name

### carts
```sql
user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
total_amount DECIMAL(15,2) NOT NULL DEFAULT 0 CHECK (total_amount >= 0)
total_items INT NOT NULL DEFAULT 0 CHECK (total_items >= 0)
```
Indexes:
- `idx_carts_user_id` WHERE deleted_at IS NULL

Constraints:
- `unique_user_cart_not_deleted` UNIQUE NULLS NOT DISTINCT (user_id, deleted_at)

### cart_items
```sql
cart_id UUID NOT NULL REFERENCES carts(id) ON DELETE CASCADE
product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT
quantity INT NOT NULL CHECK (quantity > 0)
unit_price DECIMAL(15,2) NOT NULL CHECK (unit_price >= 0)
total_price DECIMAL(15,2) NOT NULL CHECK (total_price >= 0)
```
Indexes:
- `idx_cart_items_cart_id` WHERE deleted_at IS NULL
- `idx_cart_items_product_id` WHERE deleted_at IS NULL

Constraints:
- `unique_cart_product_not_deleted` UNIQUE NULLS NOT DISTINCT (cart_id, product_id, deleted_at)

### orders
```sql
order_number VARCHAR(50) NOT NULL
user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT
status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
total_amount DECIMAL(15,2) NOT NULL CHECK (total_amount >= 0)
shipping_fee DECIMAL(15,2) NOT NULL DEFAULT 0 CHECK (shipping_fee >= 0)
payment_method VARCHAR(50) NOT NULL
payment_status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
notes TEXT
shipping_address_id UUID NOT NULL REFERENCES user_addresses(id) ON DELETE RESTRICT
```
Indexes:
- `idx_orders_user_id` WHERE deleted_at IS NULL
- `idx_orders_order_number` WHERE deleted_at IS NULL
- `idx_orders_status` WHERE deleted_at IS NULL
- `idx_orders_payment_status` WHERE deleted_at IS NULL
- `idx_orders_shipping_address_id` WHERE deleted_at IS NULL
- `idx_orders_created_at` WHERE deleted_at IS NULL

Constraints:
- `unique_order_number_not_deleted` UNIQUE NULLS NOT DISTINCT (order_number, deleted_at)

### order_items
```sql
order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE
product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT
quantity INT NOT NULL CHECK (quantity > 0)
unit_price DECIMAL(15,2) NOT NULL CHECK (unit_price >= 0)
total_price DECIMAL(15,2) NOT NULL CHECK (total_price >= 0)
```
Indexes:
- `idx_order_items_order_id` WHERE deleted_at IS NULL
- `idx_order_items_product_id` WHERE deleted_at IS NULL

### payments
```sql
order_id UUID NOT NULL REFERENCES orders(id) ON DELETE RESTRICT
amount DECIMAL(15,2) NOT NULL CHECK (amount >= 0)
provider VARCHAR(50) NOT NULL
status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
transaction_id VARCHAR(100)
payment_method VARCHAR(50) NOT NULL
```
Indexes:
- `idx_payments_order_id` WHERE deleted_at IS NULL
- `idx_payments_status` WHERE deleted_at IS NULL
- `idx_payments_transaction_id` WHERE deleted_at IS NULL

Constraints:
- `unique_transaction_id_not_deleted` UNIQUE NULLS NOT DISTINCT (transaction_id, deleted_at)

## Migration History

1. V1__Create_Base_Tables.sql
   - Tạo extension UUID
   - Tạo bảng users với role và status
   - Tạo bảng categories với parent_id và display_order
   - Tạo bảng user_addresses với thông tin địa chỉ chi tiết

2. V2__Create_Product_Tables.sql
   - Tạo bảng products với giá, số lượng, trạng thái
   - Tạo bảng product_images với is_primary và display_order
   - Tạo bảng product_reviews với trigger cập nhật user_name

3. V3__Create_Order_Tables.sql
   - Tạo bảng carts và cart_items cho giỏ hàng
   - Tạo bảng orders với thông tin đơn hàng và thanh toán
   - Tạo bảng order_items với chi tiết đơn hàng
   - Tạo bảng payments với thông tin thanh toán

4. V4__Add_Sample_Data.sql
   - Thêm dữ liệu mẫu cho tất cả các bảng

## Tính năng Đặc biệt

1. Soft Delete
   - Tất cả bảng đều hỗ trợ soft delete
   - Sử dụng deleted_at và is_deleted
   - Unique constraints với NULLS NOT DISTINCT
   - Indexes có điều kiện WHERE deleted_at IS NULL

2. Audit Trail
   - Theo dõi người tạo và cập nhật
   - Thời gian tạo và cập nhật
   - Tích hợp với Spring Data JPA Auditing

3. Data Integrity
   - Check constraints cho số lượng và giá cả
   - Foreign key với ON DELETE RESTRICT/CASCADE
   - Unique constraints cho các trường quan trọng
   - Trigger tự động cập nhật dữ liệu liên quan

4. Performance
   - Indexes cho các trường tìm kiếm thường xuyên
   - Composite indexes cho các điều kiện phức tạp
   - Partial indexes với WHERE clause
   - UUID cho primary key và foreign key 