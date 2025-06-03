-- Insert sample users
INSERT INTO users (id, username, email, password, full_name, phone, role)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'admin', 'admin@d7shop.com', '$2a$10$rS.F0jGmxUB.0Wr2tXAVfu8df3h3QT6PTgqJkVpZHxlbxBJkhT2Oi', 'System Admin', '0123456789', 'ADMIN'),
    ('22222222-2222-2222-2222-222222222222', 'user1', 'user1@example.com', '$2a$10$rS.F0jGmxUB.0Wr2tXAVfu8df3h3QT6PTgqJkVpZHxlbxBJkhT2Oi', 'User One', '0987654321', 'USER'),
    ('33333333-3333-3333-3333-333333333333', 'user2', 'user2@example.com', '$2a$10$rS.F0jGmxUB.0Wr2tXAVfu8df3h3QT6PTgqJkVpZHxlbxBJkhT2Oi', 'User Two', '0909090909', 'USER');

-- Insert sample categories
INSERT INTO categories (id, name, slug, description, status, display_order)
VALUES
    ('44444444-4444-4444-4444-444444444444', 'Electronics', 'electronics', 'Electronic devices and accessories', 'ACTIVE', 1),
    ('55555555-5555-5555-5555-555555555555', 'Smartphones', 'smartphones', 'Mobile phones and accessories', 'ACTIVE', 2),
    ('66666666-6666-6666-6666-666666666666', 'Laptops', 'laptops', 'Laptops and accessories', 'ACTIVE', 3);

-- Set parent categories
UPDATE categories 
SET parent_id = '44444444-4444-4444-4444-444444444444'
WHERE id IN ('55555555-5555-5555-5555-555555555555', '66666666-6666-6666-6666-666666666666');

-- Insert sample products
INSERT INTO products (id, name, slug, description, category_id, price, sale_price, stock_quantity, sku, status, enabled, featured)
VALUES
    ('77777777-7777-7777-7777-777777777777', 'iPhone 15 Pro', 'iphone-15-pro', 'Latest iPhone model', '55555555-5555-5555-5555-555555555555', 999.99, 949.99, 100, 'IP15P-001', 'ACTIVE', true, true),
    ('88888888-8888-8888-8888-888888888888', 'MacBook Pro M3', 'macbook-pro-m3', 'Latest MacBook model', '66666666-6666-6666-6666-666666666666', 1999.99, NULL, 50, 'MBP-M3-001', 'ACTIVE', true, true),
    ('99999999-9999-9999-9999-999999999999', 'Samsung S24 Ultra', 'samsung-s24-ultra', 'Latest Samsung model', '55555555-5555-5555-5555-555555555555', 1199.99, 1099.99, 75, 'SS24U-001', 'ACTIVE', true, false);

-- Insert sample product images
INSERT INTO product_images (product_id, image_url, is_primary, display_order)
VALUES
    ('77777777-7777-7777-7777-777777777777', '/images/products/iphone-15-pro-1.jpg', true, 1),
    ('77777777-7777-7777-7777-777777777777', '/images/products/iphone-15-pro-2.jpg', false, 2),
    ('88888888-8888-8888-8888-888888888888', '/images/products/macbook-pro-m3-1.jpg', true, 1),
    ('99999999-9999-9999-9999-999999999999', '/images/products/samsung-s24-ultra-1.jpg', true, 1);

-- Insert sample user addresses
INSERT INTO user_addresses (id, user_id, recipient_name, phone, address_line1, city, country, is_default)
VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', 'User One', '0987654321', '123 User St', 'Ho Chi Minh', 'Vietnam', true),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '33333333-3333-3333-3333-333333333333', 'User Two', '0909090909', '456 User St', 'Ha Noi', 'Vietnam', true);

-- Insert sample carts
INSERT INTO carts (id, user_id, total_amount, total_items)
VALUES
    ('cccccccc-cccc-cccc-cccc-cccccccccccc', '22222222-2222-2222-2222-222222222222', 999.99, 1),
    ('dddddddd-dddd-dddd-dddd-dddddddddddd', '33333333-3333-3333-3333-333333333333', 2199.98, 2);

-- Insert sample cart items
INSERT INTO cart_items (cart_id, product_id, quantity, unit_price, total_price)
VALUES
    ('cccccccc-cccc-cccc-cccc-cccccccccccc', '77777777-7777-7777-7777-777777777777', 1, 999.99, 999.99),
    ('dddddddd-dddd-dddd-dddd-dddddddddddd', '88888888-8888-8888-8888-888888888888', 1, 1999.99, 1999.99),
    ('dddddddd-dddd-dddd-dddd-dddddddddddd', '99999999-9999-9999-9999-999999999999', 1, 199.99, 199.99);

-- Insert sample orders
INSERT INTO orders (id, order_number, user_id, status, total_amount, shipping_fee, payment_method, payment_status, shipping_address_id)
VALUES
    ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'ORD-2024-0001', '22222222-2222-2222-2222-222222222222', 'COMPLETED', 1049.99, 50.00, 'CREDIT_CARD', 'PAID', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
    ('ffffffff-ffff-ffff-ffff-ffffffffffff', 'ORD-2024-0002', '33333333-3333-3333-3333-333333333333', 'PROCESSING', 2049.99, 50.00, 'BANK_TRANSFER', 'PENDING', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price)
VALUES
    ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '77777777-7777-7777-7777-777777777777', 1, 999.99, 999.99),
    ('ffffffff-ffff-ffff-ffff-ffffffffffff', '88888888-8888-8888-8888-888888888888', 1, 1999.99, 1999.99);

-- Insert sample payments
INSERT INTO payments (order_id, amount, provider, status, transaction_id, payment_method)
VALUES
    ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 1049.99, 'STRIPE', 'COMPLETED', 'TXN-2024-0001', 'CREDIT_CARD'),
    ('ffffffff-ffff-ffff-ffff-ffffffffffff', 2049.99, 'VNPAY', 'PENDING', 'TXN-2024-0002', 'BANK_TRANSFER');

-- Insert sample product reviews
INSERT INTO product_reviews (product_id, user_id, rating, comment, status)
VALUES
    ('77777777-7777-7777-7777-777777777777', '22222222-2222-2222-2222-222222222222', 5, 'Great product!', 'APPROVED'),
    ('88888888-8888-8888-8888-888888888888', '33333333-3333-3333-3333-333333333333', 4, 'Good but expensive', 'APPROVED');

-- Update product ratings
UPDATE products
SET average_rating = 5.0, review_count = 1
WHERE id = '77777777-7777-7777-7777-777777777777';

UPDATE products
SET average_rating = 4.0, review_count = 1
WHERE id = '88888888-8888-8888-8888-888888888888'; 