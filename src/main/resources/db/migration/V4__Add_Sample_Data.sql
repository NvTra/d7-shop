-- V4__Add_Sample_Data.sql

-- Insert sample users
INSERT INTO users (username, email, password_hash, full_name, role)
VALUES 
('admin', 'admin@d7shop.com', '$2a$10$rS.bCzKFBAXHyY.2/OQKEeGWnwzw0JKhqKrS9Kv5Xs5z.j8rY5vEe', 'Admin User', 'ADMIN'),
('user1', 'user1@example.com', '$2a$10$rS.bCzKFBAXHyY.2/OQKEeGWnwzw0JKhqKrS9Kv5Xs5z.j8rY5vEe', 'User One', 'USER');

-- Insert sample categories
INSERT INTO categories (name, slug, description)
VALUES 
('Electronics', 'electronics', 'Electronic devices and accessories'),
('Clothing', 'clothing', 'Fashion and apparel'),
('Books', 'books', 'Books and publications');

-- Insert sample products
INSERT INTO products (name, slug, description, category_id, price, stock_quantity, sku)
VALUES 
('Smartphone X', 'smartphone-x', 'Latest smartphone with amazing features', 1, 999.99, 50, 'PHONE-001'),
('Laptop Pro', 'laptop-pro', 'Professional laptop for developers', 1, 1499.99, 30, 'LAPTOP-001'),
('T-Shirt Basic', 't-shirt-basic', 'Comfortable cotton t-shirt', 2, 19.99, 100, 'SHIRT-001');

-- Insert sample addresses
INSERT INTO user_addresses (user_id, recipient_name, phone, address_line1, city, country, is_default)
VALUES 
(1, 'Admin User', '1234567890', '123 Admin Street', 'Admin City', 'Vietnam', true),
(2, 'User One', '0987654321', '456 User Street', 'User City', 'Vietnam', true); 