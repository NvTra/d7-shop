 -- V2__Create_Product_Tables.sql

-- Create products table (không khai báo constraint UNIQUE ở đây)
 CREATE TABLE products (
                           id BIGSERIAL PRIMARY KEY,
                           name VARCHAR(255) NOT NULL,
                           slug VARCHAR(255) NOT NULL,
                           description TEXT,
                           category_id BIGINT NOT NULL,
                           price DECIMAL(15,2) NOT NULL,
                           sale_price DECIMAL(15,2),
                           stock_quantity INT NOT NULL DEFAULT 0,
                           sku VARCHAR(50),
                           status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
                           created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           deleted_at TIMESTAMP,
                           CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(id)
 );

-- Thêm constraint UNIQUE sau, có kiểm tra tồn tại
 DO $$
     BEGIN
         IF NOT EXISTS (
             SELECT 1 FROM pg_constraint WHERE conname = 'unique_slug_not_deleted'
         ) THEN
             ALTER TABLE products
                 ADD CONSTRAINT unique_slug_not_deleted UNIQUE NULLS NOT DISTINCT (slug, deleted_at);
         END IF;

         IF NOT EXISTS (
             SELECT 1 FROM pg_constraint WHERE conname = 'unique_sku_not_deleted'
         ) THEN
             ALTER TABLE products
                 ADD CONSTRAINT unique_sku_not_deleted UNIQUE NULLS NOT DISTINCT (sku, deleted_at);
         END IF;
     END $$;

-- Các index khác
 CREATE INDEX idx_products_category_id ON products(category_id) WHERE deleted_at IS NULL;
 CREATE INDEX idx_products_slug ON products(slug) WHERE deleted_at IS NULL;
 CREATE INDEX idx_products_status ON products(status) WHERE deleted_at IS NULL;
 CREATE INDEX idx_products_deleted_at ON products(deleted_at);

-- product_images table
 CREATE TABLE product_images (
                                 id BIGSERIAL PRIMARY KEY,
                                 product_id BIGINT NOT NULL,
                                 image_url VARCHAR(255) NOT NULL,
                                 is_primary BOOLEAN NOT NULL DEFAULT false,
                                 display_order INT NOT NULL DEFAULT 0,
                                 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                 CONSTRAINT fk_product_images_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
 );
 CREATE INDEX idx_product_images_product_id ON product_images(product_id);

-- product_reviews table
 CREATE TABLE product_reviews (
                                  id BIGSERIAL PRIMARY KEY,
                                  product_id BIGINT NOT NULL,
                                  user_id BIGINT NOT NULL,
                                  rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
                                  comment TEXT,
                                  status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
                                  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  deleted_at TIMESTAMP,
                                  CONSTRAINT fk_product_reviews_product FOREIGN KEY (product_id) REFERENCES products(id),
                                  CONSTRAINT fk_product_reviews_user FOREIGN KEY (user_id) REFERENCES users(id)
 );
 CREATE INDEX idx_product_reviews_product_id ON product_reviews(product_id) WHERE deleted_at IS NULL;
 CREATE INDEX idx_product_reviews_user_id ON product_reviews(user_id) WHERE deleted_at IS NULL;
 CREATE INDEX idx_product_reviews_deleted_at ON product_reviews(deleted_at);
