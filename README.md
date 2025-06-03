# D7-Shop

D7-Shop là một hệ thống backend RESTful API cho ứng dụng thương mại điện tử, được xây dựng bằng Java/Spring Boot.

## Yêu cầu hệ thống

- Java 17+ LTS
- Maven 3.8+
- PostgreSQL 14+
- Git

## Cấu hình môi trường

### Biến môi trường có sẵn

#### Database
- `DB_URL`: URL kết nối database (mặc định: jdbc:postgresql://localhost:5432/d7shop)
- `DB_USERNAME`: Username database (mặc định: d7shop_dev)
- `DB_PASSWORD`: Password database (mặc định: dev_password)
- `DB_DRIVER`: Driver class name (mặc định: org.postgresql.Driver)
- `DB_MAX_POOL_SIZE`: Kích thước pool tối đa (mặc định: 10)
- `DB_MIN_IDLE`: Số kết nối idle tối thiểu (mặc định: 5)
- `DB_IDLE_TIMEOUT`: Thời gian timeout (mặc định: 300000)

#### JPA/Hibernate
- `JPA_DDL_AUTO`: Chế độ DDL (mặc định: validate)
- `JPA_SHOW_SQL`: Hiển thị SQL (mặc định: true)
- `JPA_FORMAT_SQL`: Format SQL (mặc định: true)

#### Security
- `JWT_SECRET`: Khóa bí mật cho JWT (mặc định: d7shop_development_jwt_secret_key_2024)
- `JWT_EXPIRATION`: Thời gian hết hạn JWT (mặc định: 86400000)
- `ADMIN_USERNAME`: Username admin mặc định (mặc định: admin)
- `ADMIN_PASSWORD`: Password admin mặc định (mặc định: admin)
- `ADMIN_ROLES`: Roles admin mặc định (mặc định: ADMIN)

#### Server
- `SERVER_PORT`: Port máy chủ (mặc định: 8080)
- `SERVER_ERROR_MESSAGE`: Hiển thị message lỗi (mặc định: always)
- `SERVER_ERROR_BINDING`: Hiển thị binding errors (mặc định: always)

#### Logging
- `LOG_LEVEL_ROOT`: Log level cho root (mặc định: INFO)
- `LOG_LEVEL_APP`: Log level cho ứng dụng (mặc định: DEBUG)
- `LOG_LEVEL_SQL`: Log level cho SQL (mặc định: DEBUG)
- `LOG_LEVEL_SECURITY`: Log level cho security (mặc định: DEBUG)

### Môi trường phát triển

Trong môi trường development, bạn có thể:
1. Sử dụng các giá trị mặc định
2. Override bằng biến môi trường khi cần thiết

### Môi trường test

Để chạy ứng dụng trong môi trường test:
```bash
./mvnw spring-boot:run -Dspring.profiles.active=test
```

## Thiết lập môi trường phát triển

### Cài đặt thủ công

1. Clone repository:
```bash
git clone <repository-url>
cd d7-shop
```

2. Cài đặt PostgreSQL:
- Tạo database 'd7shop'
- Tạo database 'd7shop_test' cho testing
- Tạo user 'd7shop_dev' với mật khẩu 'dev_password'
- Cấp quyền cho user:
```sql
GRANT ALL ON SCHEMA public TO d7shop_dev;
GRANT ALL ON ALL TABLES IN SCHEMA public TO d7shop_dev;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO d7shop_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO d7shop_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO d7shop_dev;
```

3. Chạy migrations:
```bash
./mvnw spring-boot:run
```

4. Kiểm tra ứng dụng:
- API Documentation: http://localhost:8080/swagger-ui.html
- API Endpoints: http://localhost:8080/api-docs

## Cấu trúc thư mục

```
d7-shop/
├── src/
│   ├── main/
│   │   ├── java/          # Mã nguồn Java
│   │   └── resources/
│   │       ├── db/        # Flyway migrations
│   │       ├── static/    # File tĩnh (images, css, js)
│   │       └── templates/ # Thymeleaf templates
│   └── test/             # Unit tests
├── logs/                 # Application logs
└── target/              # Compiled files
```

## Cấu hình

### Database
- URL: jdbc:postgresql://localhost:5432/d7shop
- Username: d7shop_dev
- Password: dev_password

### Logging
- Log files: ./logs/d7shop.log
- Archived logs: ./logs/archived/
- Log levels:
  - Root: INFO
  - Application: DEBUG
  - Spring Security: DEBUG
  - SQL: DEBUG

### Security
- Default admin account:
  - Username: admin
  - Password: admin
  - Role: ADMIN

### API Documentation
- Swagger UI: http://localhost:8080/swagger-ui.html
- OpenAPI Spec: http://localhost:8080/api-docs

## Phát triển

### Thêm migrations mới
1. Tạo file migration trong `src/main/resources/db/migration`
2. Đặt tên theo format: `V{version}__{description}.sql`
3. Chạy `./mvnw spring-boot:run` để áp dụng migrations

### Logging
- Cấu hình logging trong `src/main/resources/logback-spring.xml`
- Log files được lưu trong thư mục `logs`
- Log files được tự động xoay vòng khi đạt 10MB
- Giữ logs trong 30 ngày
- Tổng dung lượng logs tối đa 3GB

## Công nghệ sử dụng

- Spring Boot 3+
- Spring Security với JWT
- Spring Data JPA & Hibernate
- PostgreSQL
- Flyway
- Maven
- Thymeleaf

## Tài liệu API

API documentation có sẵn tại: `http://localhost:8080/swagger-ui.html`

## Môi trường

- Development: `application.yml`
- Testing: `application-test.yml`
- Production: `application-prod.yml`

## Quy tắc phát triển

1. Sử dụng Git Flow
2. Tuân thủ code style
3. Viết unit tests
4. Cập nhật documentation

## Liên hệ

[Thông tin liên hệ của team] 