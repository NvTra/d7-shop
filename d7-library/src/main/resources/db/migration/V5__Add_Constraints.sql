-- Add CHECK constraints for numeric fields
ALTER TABLE products ADD CONSTRAINT chk_products_price CHECK (price >= 0);
ALTER TABLE products ADD CONSTRAINT chk_products_sale_price CHECK (sale_price >= 0 AND sale_price <= price);
ALTER TABLE products ADD CONSTRAINT chk_products_quantity CHECK (quantity >= 0);

ALTER TABLE cart_items ADD CONSTRAINT chk_cart_items_quantity CHECK (quantity >= 0);
ALTER TABLE cart_items ADD CONSTRAINT chk_cart_items_price CHECK (price >= 0);

ALTER TABLE order_items ADD CONSTRAINT chk_order_items_quantity CHECK (quantity >= 0);
ALTER TABLE order_items ADD CONSTRAINT chk_order_items_price CHECK (price >= 0);

ALTER TABLE product_reviews ADD CONSTRAINT chk_product_reviews_rating CHECK (rating >= 1 AND rating <= 5);

-- Add UNIQUE constraints with NULLS NOT DISTINCT
ALTER TABLE users ADD CONSTRAINT uk_users_email UNIQUE NULLS NOT DISTINCT (email) WHERE deleted_at IS NULL;
ALTER TABLE users ADD CONSTRAINT uk_users_username UNIQUE NULLS NOT DISTINCT (username) WHERE deleted_at IS NULL;

ALTER TABLE categories ADD CONSTRAINT uk_categories_name UNIQUE NULLS NOT DISTINCT (name) WHERE deleted_at IS NULL;

ALTER TABLE products ADD CONSTRAINT uk_products_sku UNIQUE NULLS NOT DISTINCT (sku) WHERE deleted_at IS NULL;

-- Add conditional indexes
CREATE INDEX idx_users_email ON users (email) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_username ON users (username) WHERE deleted_at IS NULL;

CREATE INDEX idx_categories_name ON categories (name) WHERE deleted_at IS NULL;

CREATE INDEX idx_products_name ON products (name) WHERE deleted_at IS NULL;
CREATE INDEX idx_products_sku ON products (sku) WHERE deleted_at IS NULL;
CREATE INDEX idx_products_category_id ON products (category_id) WHERE deleted_at IS NULL;

CREATE INDEX idx_cart_items_cart_id ON cart_items (cart_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_cart_items_product_id ON cart_items (product_id) WHERE deleted_at IS NULL;

CREATE INDEX idx_order_items_order_id ON order_items (order_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_order_items_product_id ON order_items (product_id) WHERE deleted_at IS NULL;

CREATE INDEX idx_product_reviews_product_id ON product_reviews (product_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_product_reviews_user_id ON product_reviews (user_id) WHERE deleted_at IS NULL;

-- Add trigger for auto-updating user_name in product_reviews
CREATE OR REPLACE FUNCTION update_review_user_name()
RETURNS TRIGGER AS $$
BEGIN
    NEW.user_name = (SELECT username FROM users WHERE id = NEW.user_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_review_user_name
    BEFORE INSERT OR UPDATE ON product_reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_review_user_name(); 