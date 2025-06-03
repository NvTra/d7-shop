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
full_name VARCHAR(100) NOT NULL
phone VARCHAR(20)
role VARCHAR(20) NOT NULL DEFAULT 'USER'
status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'

-- Constraints
UNIQUE NULLS NOT DISTINCT (username, deleted_at)
UNIQUE NULLS NOT DISTINCT (email, deleted_at)

-- Indexes
idx_users_email ON (email) WHERE deleted_at IS NULL
idx_users_username ON (username) WHERE deleted_at IS NULL
idx_users_role ON (role) WHERE deleted_at IS NULL
idx_users_status ON (status) WHERE deleted_at IS NULL
```

### categories
```sql
name VARCHAR(100) NOT NULL
slug VARCHAR(100) NOT NULL
description TEXT
image_url VARCHAR(255)
parent_id UUID REFERENCES categories(id) ON DELETE SET NULL
status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
display_order INT NOT NULL DEFAULT 0

-- Constraints
UNIQUE NULLS NOT DISTINCT (slug, deleted_at)

-- Indexes
idx_categories_parent_id ON (parent_id) WHERE deleted_at IS NULL
idx_categories_slug ON (slug) WHERE deleted_at IS NULL
idx_categories_status ON (status) WHERE deleted_at IS NULL
idx_categories_display_order ON (display_order) WHERE deleted_at IS NULL
```

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

-- Constraints
UNIQUE NULLS NOT DISTINCT (slug, deleted_at)
UNIQUE NULLS NOT DISTINCT (sku, deleted_at)

-- Indexes
idx_products_category_id ON (category_id) WHERE deleted_at IS NULL
idx_products_slug ON (slug) WHERE deleted_at IS NULL
idx_products_sku ON (sku) WHERE deleted_at IS NULL
idx_products_status ON (status) WHERE deleted_at IS NULL
idx_products_enabled ON (enabled) WHERE deleted_at IS NULL
idx_products_featured ON (featured) WHERE deleted_at IS NULL AND enabled = TRUE
```

### product_images
```sql
product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE
image_url VARCHAR(255) NOT NULL
is_primary BOOLEAN NOT NULL DEFAULT FALSE
display_order INT NOT NULL DEFAULT 0

-- Indexes
idx_product_images_product_id ON (product_id) WHERE deleted_at IS NULL
idx_product_images_is_primary ON (is_primary) WHERE deleted_at IS NULL
idx_product_images_display_order ON (display_order) WHERE deleted_at IS NULL
```

### product_reviews
```sql
product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE
user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
user_name VARCHAR(100) NOT NULL
rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5)
comment TEXT
status VARCHAR(20) NOT NULL DEFAULT 'PENDING'

-- Indexes
idx_product_reviews_product_id ON (product_id) WHERE deleted_at IS NULL
idx_product_reviews_user_id ON (user_id) WHERE deleted_at IS NULL
idx_product_reviews_rating ON (rating) WHERE deleted_at IS NULL
idx_product_reviews_status ON (status) WHERE deleted_at IS NULL
```

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

-- Indexes
idx_user_addresses_user_id ON (user_id) WHERE deleted_at IS NULL
idx_user_addresses_is_default ON (is_default) WHERE deleted_at IS NULL AND is_default = true
```

### carts
```sql
user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
total_amount DECIMAL(15,2) NOT NULL DEFAULT 0 CHECK (total_amount >= 0)
total_items INT NOT NULL DEFAULT 0 CHECK (total_items >= 0)

-- Constraints
UNIQUE NULLS NOT DISTINCT (user_id, deleted_at)

-- Indexes
idx_carts_user_id ON (user_id) WHERE deleted_at IS NULL
```

### cart_items
```sql
cart_id UUID NOT NULL REFERENCES carts(id) ON DELETE CASCADE
product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT
quantity INT NOT NULL CHECK (quantity > 0)
unit_price DECIMAL(15,2) NOT NULL CHECK (unit_price >= 0)
total_price DECIMAL(15,2) NOT NULL CHECK (total_price >= 0)

-- Constraints
UNIQUE NULLS NOT DISTINCT (cart_id, product_id, deleted_at)

-- Indexes
idx_cart_items_cart_id ON (cart_id) WHERE deleted_at IS NULL
idx_cart_items_product_id ON (product_id) WHERE deleted_at IS NULL
```

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

-- Constraints
UNIQUE NULLS NOT DISTINCT (order_number, deleted_at)

-- Indexes
idx_orders_user_id ON (user_id) WHERE deleted_at IS NULL
idx_orders_order_number ON (order_number) WHERE deleted_at IS NULL
idx_orders_status ON (status) WHERE deleted_at IS NULL
idx_orders_payment_status ON (payment_status) WHERE deleted_at IS NULL
idx_orders_shipping_address_id ON (shipping_address_id) WHERE deleted_at IS NULL
idx_orders_created_at ON (created_at) WHERE deleted_at IS NULL
```

### order_items
```sql
order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE
product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT
quantity INT NOT NULL CHECK (quantity > 0)
unit_price DECIMAL(15,2) NOT NULL CHECK (unit_price >= 0)
total_price DECIMAL(15,2) NOT NULL CHECK (total_price >= 0)

-- Indexes
idx_order_items_order_id ON (order_id) WHERE deleted_at IS NULL
idx_order_items_product_id ON (product_id) WHERE deleted_at IS NULL
```

### payments
```sql
order_id UUID NOT NULL REFERENCES orders(id) ON DELETE RESTRICT
amount DECIMAL(15,2) NOT NULL CHECK (amount >= 0)
provider VARCHAR(50) NOT NULL
status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
transaction_id VARCHAR(100)
payment_method VARCHAR(50) NOT NULL

-- Constraints
UNIQUE NULLS NOT DISTINCT (transaction_id, deleted_at)

-- Indexes
idx_payments_order_id ON (order_id) WHERE deleted_at IS NULL
idx_payments_status ON (status) WHERE deleted_at IS NULL
idx_payments_transaction_id ON (transaction_id) WHERE deleted_at IS NULL
```

## Triggers

### update_review_user_name
```sql
-- Tự động cập nhật user_name trong product_reviews từ users
CREATE OR REPLACE FUNCTION update_review_user_name()
RETURNS TRIGGER AS $$
BEGIN
    SELECT full_name INTO NEW.user_name
    FROM users
    WHERE id = NEW.user_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_update_review_user_name
BEFORE INSERT OR UPDATE ON product_reviews
FOR EACH ROW
EXECUTE FUNCTION update_review_user_name();
``` 