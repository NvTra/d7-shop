-- Create products table
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    description TEXT,
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    price DECIMAL(15,2) NOT NULL CHECK (price >= 0),
    sale_price DECIMAL(15,2) CHECK (sale_price >= 0 AND (sale_price IS NULL OR sale_price <= price)),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    sku VARCHAR(50),
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    featured BOOLEAN NOT NULL DEFAULT FALSE,
    average_rating DOUBLE PRECISION,
    review_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(255),
    updated_at TIMESTAMP,
    updated_by VARCHAR(255),
    deleted_at TIMESTAMP,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT unique_product_slug_not_deleted UNIQUE NULLS NOT DISTINCT (slug, deleted_at),
    CONSTRAINT unique_product_sku_not_deleted UNIQUE NULLS NOT DISTINCT (sku, deleted_at)
);

-- Create product_images table
CREATE TABLE product_images (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    display_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(255),
    updated_at TIMESTAMP,
    updated_by VARCHAR(255),
    deleted_at TIMESTAMP,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);

-- Create product_reviews table
CREATE TABLE product_reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_name VARCHAR(100) NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(255),
    updated_at TIMESTAMP,
    updated_by VARCHAR(255),
    deleted_at TIMESTAMP,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);

-- Create trigger to update product_reviews.user_name from users table
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

-- Create indexes
CREATE INDEX idx_products_category_id ON products(category_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_products_slug ON products(slug) WHERE deleted_at IS NULL;
CREATE INDEX idx_products_sku ON products(sku) WHERE deleted_at IS NULL;
CREATE INDEX idx_products_status ON products(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_products_enabled ON products(enabled) WHERE deleted_at IS NULL;
CREATE INDEX idx_products_featured ON products(featured) WHERE deleted_at IS NULL AND enabled = TRUE;
CREATE INDEX idx_products_deleted_at ON products(deleted_at);

CREATE INDEX idx_product_images_product_id ON product_images(product_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_product_images_is_primary ON product_images(is_primary) WHERE deleted_at IS NULL;
CREATE INDEX idx_product_images_display_order ON product_images(display_order) WHERE deleted_at IS NULL;
CREATE INDEX idx_product_images_deleted_at ON product_images(deleted_at);

CREATE INDEX idx_product_reviews_product_id ON product_reviews(product_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_product_reviews_user_id ON product_reviews(user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_product_reviews_rating ON product_reviews(rating) WHERE deleted_at IS NULL;
CREATE INDEX idx_product_reviews_status ON product_reviews(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_product_reviews_deleted_at ON product_reviews(deleted_at); 