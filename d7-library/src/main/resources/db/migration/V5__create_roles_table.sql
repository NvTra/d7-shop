CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(255),
    updated_at TIMESTAMP,
    updated_by VARCHAR(255),
    deleted_at TIMESTAMP,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT unique_role_name_not_deleted UNIQUE NULLS NOT DISTINCT (name, deleted_at)
);

-- Insert default roles
INSERT INTO roles (id, name, description)
VALUES 
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'ADMIN', 'Administrator with full access'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'USER', 'Regular user with basic access');

-- Thêm cột role_id vào bảng users với giá trị mặc định là USER role
ALTER TABLE users
ADD COLUMN role_id UUID NOT NULL DEFAULT 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11' REFERENCES roles(id);

-- Tạo index cho role_id
CREATE INDEX idx_users_role_id ON users(role_id) WHERE deleted_at IS NULL; 