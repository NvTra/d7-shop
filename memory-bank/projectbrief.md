# Project Brief

## Overview
D7-Shop là một nền tảng thương mại điện tử hiện đại được xây dựng trên Spring Boot. Hệ thống được thiết kế với kiến trúc microservices, sử dụng các công nghệ và thực tiễn tốt nhất trong ngành.

## Core Features

### User Management
- Đăng ký và đăng nhập
- Quản lý thông tin cá nhân
- Quản lý địa chỉ giao hàng
- Phân quyền người dùng (ADMIN/USER)

### Product Management
- Quản lý danh mục sản phẩm
- Quản lý sản phẩm với hình ảnh
- Hỗ trợ giá khuyến mãi
- Đánh giá và nhận xét sản phẩm

### Shopping Features
- Giỏ hàng thông minh
- Quản lý đơn hàng
- Tích hợp thanh toán
- Theo dõi trạng thái đơn hàng

### Admin Features
- Quản lý người dùng
- Quản lý sản phẩm và danh mục
- Quản lý đơn hàng
- Báo cáo và thống kê

## Technical Requirements

### Performance
- Thời gian phản hồi API < 500ms
- Hỗ trợ đồng thời 1000+ người dùng
- Tối ưu hóa database queries
- Caching cho dữ liệu tĩnh

### Security
- JWT authentication
- Role-based access control
- Mã hóa mật khẩu
- API rate limiting
- Validation đầu vào

### Scalability
- Microservices architecture
- Database optimization
- Caching strategy
- Load balancing

### Reliability
- Transaction management
- Error handling
- Logging và monitoring
- Backup và recovery

## Project Structure

### Backend Services
1. d7-library
   - Common components
   - Database entities
   - Shared utilities

2. d7-admin-service
   - Admin dashboard API
   - Reporting features
   - System management

3. d7-enduser-service
   - Public API
   - Shopping features
   - User management

### Database Design
- UUID primary keys
- Audit fields
- Soft delete
- Optimized indexes
- Data validation

## Mục tiêu
Xây dựng một hệ thống thương mại điện tử với kiến trúc microservices, cho phép quản lý và bán sản phẩm trực tuyến.

## Yêu cầu chức năng

### Admin Service (d7-admin-service)
1. Quản lý danh mục
   - CRUD danh mục sản phẩm
   - Hỗ trợ danh mục đa cấp
   - Bật/tắt hiển thị danh mục

2. Quản lý sản phẩm
   - CRUD sản phẩm
   - Quản lý hình ảnh sản phẩm
   - Quản lý giá và giá khuyến mãi
   - Quản lý tồn kho
   - Đánh dấu sản phẩm nổi bật

3. Quản lý đơn hàng
   - Xem danh sách đơn hàng
   - Cập nhật trạng thái đơn hàng
   - Xem chi tiết đơn hàng

### Enduser Service (d7-enduser-service)
1. Danh mục và sản phẩm
   - Xem danh sách danh mục
   - Xem danh sách sản phẩm theo danh mục
   - Xem chi tiết sản phẩm
   - Tìm kiếm sản phẩm
   - Xem sản phẩm nổi bật

2. Đơn hàng
   - Tạo đơn hàng mới
   - Xem lịch sử đơn hàng
   - Xem chi tiết đơn hàng

### Library Module (d7-library)
1. Entities và Repositories
   - Quản lý các entity chung
   - Cung cấp các repository để truy cập dữ liệu
   - Xử lý migration database

2. DTOs và Exceptions
   - Định nghĩa các DTO cho request/response
   - Xử lý các exception chung

## Yêu cầu phi chức năng
1. Bảo mật
   - Xác thực và phân quyền người dùng
   - Bảo vệ API endpoints

2. Hiệu năng
   - Phân trang cho các danh sách lớn
   - Tối ưu truy vấn database

3. Khả năng mở rộng
   - Kiến trúc microservices dễ dàng mở rộng
   - Tách biệt rõ ràng giữa các module

4. Logging và Monitoring
   - Ghi log chi tiết cho từng service
   - Theo dõi metrics hệ thống

## Ràng buộc
### Công nghệ
- Java 17+ LTS
- Spring Boot 3+ LTS
- Spring Data JPA & Hibernate
- PostgreSQL
- Maven/Gradle
- JWT (jjwt library)

## Phạm vi
- Xây dựng toàn bộ backend API cho hệ thống thương mại điện tử
- Tích hợp với các dịch vụ bên thứ ba (cổng thanh toán)
- Không bao gồm phát triển frontend

## Các bên liên quan
- Khách hàng mua sắm online
- Chủ cửa hàng/Admin quản lý sản phẩm
- Đội phát triển và bảo trì hệ thống

## Thời gian dự kiến
Không xác định - Dự án phát triển linh hoạt theo nhu cầu 