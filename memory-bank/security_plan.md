# Kế hoạch Triển khai Security: D7-Shop
*Phiên bản: 1.0.1*
*Tạo: 2024-03-20*
*Cập nhật lần cuối: 2024-03-21*

## Mô hình Phân quyền
Áp dụng mô hình đơn giản với User - Role. Mỗi User có một Role xác định quyền hạn của họ trong hệ thống.

### Schema Database

```sql
-- Bảng roles
CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) NOT NULL,
    description TEXT,
    -- Các trường audit từ BaseEntity
    CONSTRAINT unique_role_name_not_deleted UNIQUE NULLS NOT DISTINCT (name, deleted_at)
);

-- Cập nhật bảng users thêm role_id
ALTER TABLE users ADD COLUMN role_id UUID REFERENCES roles(id);
```

### Entities

```java
@Entity
@Table(name = "roles")
public class Role extends BaseEntity {
    @Column(nullable = false)
    private String name;
    
    private String description;
}

@Entity
@Table(name = "users")
public class User extends BaseEntity {
    // ... other fields
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "role_id")
    private Role role;
}
```

## Roles Mặc định

### Roles
1. ADMIN - Quản trị viên hệ thống
   - Quản lý toàn bộ hệ thống
   - Quản lý người dùng và roles
   - Quản lý sản phẩm và danh mục
   - Quản lý đơn hàng

2. STAFF - Nhân viên
   - Xem và cập nhật sản phẩm
   - Xem và cập nhật đơn hàng
   - Không thể quản lý người dùng và roles

3. USER - Người dùng thông thường
   - Xem sản phẩm
   - Quản lý giỏ hàng cá nhân
   - Đặt hàng và xem lịch sử đơn hàng

## Kế hoạch Triển khai

### Phase 1: Setup Cơ bản (Hiện tại)
1. Hoàn thiện schema database roles
2. Cập nhật entities và repositories
3. Triển khai JWT authentication
4. Cài đặt role-based authorization cơ bản

### Phase 2: Phát triển API
1. API đăng nhập/đăng ký
2. API quản lý role cho user
3. API kiểm tra quyền hạn cơ bản

### Phase 3: Tối ưu và Mở rộng
1. Logging và monitoring
2. Unit tests và integration tests
3. API documentation

## Monitoring và Maintenance

### Logging
- Authentication events
- Role changes
- API access attempts
- Security events

### Metrics
- Login success/failure rate
- API response times
- Security events frequency

### Alerts
- Failed login attempts
- Unauthorized access attempts
- Security events

## Documentation

### Technical Docs
- Security architecture
- API endpoints
- Database schema
- Role definitions

### User Docs
- Role descriptions
- API usage guide
- Security best practices

---

*Tài liệu này mô tả kế hoạch triển khai security đơn giản hóa cho D7-Shop.* 