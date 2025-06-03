# D7-Shop

D7-Shop là một hệ thống thương mại điện tử được xây dựng với kiến trúc microservices sử dụng Spring Boot. Hệ thống bao gồm các service chính:

- **d7-library**: Thư viện chung chứa entities, repositories và các thành phần dùng chung
- **d7-admin-service**: Backend cho trang quản trị
- **d7-enduser-service**: API công khai cho người dùng cuối

## Yêu cầu hệ thống

- Java 17+ LTS
- Maven 3.8+
- PostgreSQL 15+
- Git

## Cấu trúc dự án

```
d7-shop/
├── d7-library/           # Thư viện chung
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/    # Entities, repositories, DTOs
│   │   │   └── resources/
│   │   │       └── db/  # Flyway migrations
│   │   └── test/
├── d7-admin-service/     # Backend quản trị
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/    # Controllers, services
│   │   │   └── resources/
│   │   └── test/
├── d7-enduser-service/   # API người dùng
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/    # Controllers, services
│   │   │   └── resources/
│   │   └── test/
└── pom.xml              # Parent POM
```

## Cấu hình môi trường

### Biến môi trường

#### Database
- `DB_URL`: URL kết nối database (mặc định: jdbc:postgresql://localhost:5432/d7shop)
- `DB_USERNAME`: Username database (mặc định: d7shop_dev)
- `DB_PASSWORD`: Password database (mặc định: dev_password)
- `DB_DRIVER`: Driver class name (mặc định: org.postgresql.Driver)
- `DB_MAX_POOL_SIZE`: Kích thước pool tối đa (mặc định: 10)
- `DB_MIN_IDLE`: Số kết nối idle tối thiểu (mặc định: 5)
- `DB_IDLE_TIMEOUT`: Thời gian timeout (mặc định: 300000)

#### Security
- `JWT_SECRET`: Khóa bí mật cho JWT (mặc định: d7shop_development_jwt_secret_key_2024)
- `JWT_EXPIRATION`: Thời gian hết hạn JWT (mặc định: 86400000)
- `ADMIN_USERNAME`: Username admin mặc định (mặc định: admin)
- `ADMIN_PASSWORD`: Password admin mặc định (mặc định: admin)

#### Server
- `ADMIN_SERVICE_PORT`: Port cho admin service (mặc định: 8081)
- `ENDUSER_SERVICE_PORT`: Port cho enduser service (mặc định: 8082)

## Thiết lập môi trường phát triển

1. Clone repository:
```bash
git clone <repository-url>
cd d7-shop
```

2. Cài đặt PostgreSQL:
```sql
-- Tạo database
CREATE DATABASE d7shop;
CREATE DATABASE d7shop_test;

-- Tạo user
CREATE USER d7shop_dev WITH PASSWORD 'dev_password';

-- Cấp quyền
GRANT ALL ON DATABASE d7shop TO d7shop_dev;
GRANT ALL ON DATABASE d7shop_test TO d7shop_dev;
```

3. Build và chạy các service:
```bash
# Build toàn bộ dự án
mvn clean install

# Chạy admin service
cd d7-admin-service
mvn spring-boot:run

# Chạy enduser service
cd d7-enduser-service
mvn spring-boot:run
```

## API Documentation

### Admin Service (http://localhost:8081)
- Swagger UI: http://localhost:8081/swagger-ui.html
- OpenAPI: http://localhost:8081/api-docs

### Enduser Service (http://localhost:8082)
- Swagger UI: http://localhost:8082/swagger-ui.html
- OpenAPI: http://localhost:8082/api-docs

## Database Design

### Common Fields
Tất cả các bảng đều có các trường sau:
- `id`: UUID primary key
- `created_at`: Timestamp
- `created_by`: VARCHAR(255)
- `updated_at`: Timestamp
- `updated_by`: VARCHAR(255)
- `deleted_at`: Timestamp
- `is_deleted`: Boolean

### Migrations
- V1: Tạo bảng users, categories, user_addresses
- V2: Tạo bảng products, product_images, product_reviews
- V3: Tạo bảng carts, orders, payments
- V4: Thêm dữ liệu mẫu
- V5: Thêm constraints và indexes

## Development Guidelines

### Git Flow
- `main`: Production code
- `develop`: Development code
- `feature/*`: Tính năng mới
- `bugfix/*`: Sửa lỗi
- `release/*`: Chuẩn bị release

### Code Style
- Clean code principles
- SOLID principles
- Unit testing
- Code review

### Security
- JWT authentication
- Role-based authorization
- API security
- Input validation

## Monitoring & Logging

### Logging
- Log files: ./logs/
- Log rotation
- Archived logs: ./logs/archived/

### Monitoring
- Health checks
- Application metrics
- Performance monitoring

## Liên hệ

[Thông tin liên hệ của team] 