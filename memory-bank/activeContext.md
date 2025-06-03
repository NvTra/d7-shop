# Active Context

## Current Focus
Đang tập trung vào việc cải thiện và đồng bộ hóa cấu trúc database:

1. Chuyển đổi sang UUID cho primary keys
2. Thêm các constraint và validation
3. Tối ưu hóa indexes
4. Thêm dữ liệu mẫu có ý nghĩa

## Recent Changes
1. Cập nhật migration scripts:
   - V1__Create_Base_Tables.sql: users, categories, user_addresses
   - V2__Create_Product_Tables.sql: products, product_images, product_reviews
   - V3__Create_Order_Tables.sql: carts, orders, payments
   - V4__Add_Sample_Data.sql: dữ liệu mẫu cho tất cả các bảng
   - V5__Add_Constraints.sql: constraints và indexes

2. Thêm các constraint mới:
   - CHECK constraints cho các trường số
   - UNIQUE constraints với NULLS NOT DISTINCT
   - ON DELETE CASCADE/RESTRICT phù hợp

3. Tối ưu hóa indexes:
   - Thêm điều kiện WHERE deleted_at IS NULL
   - Index cho các trường thường xuyên tìm kiếm
   - Index có điều kiện cho các trường quan trọng

4. Cải thiện entities:
   - Thêm helper methods
   - Cập nhật relationships
   - Thêm validation
   - Tự động tính toán

## Next Actions
1. Hoàn thiện controller layer:
   - Implement các CRUD endpoints
   - Thêm custom endpoints
   - Validation và error handling

2. Triển khai security:
   - Authentication
   - Authorization
   - Role-based access control

3. Viết tests:
   - Unit tests
   - Integration tests
   - Performance tests

4. Thêm documentation:
   - API documentation
   - Code documentation
   - Deployment guide

## Current Issues
1. Cần kiểm tra lại tất cả các foreign key constraints
2. Cần đảm bảo tính nhất quán của dữ liệu mẫu
3. Cần review lại các index để tránh dư thừa

## Trạng thái dự án
- Phase hiện tại: Phase 4 - Triển khai Enduser Service
- Phase tiếp theo: Phase 5 - Triển khai Security và Authentication
- Trạng thái: Đang phát triển

## Module đã triển khai

### d7-library
- Entities: BaseEntity, User, Category, Product, ProductImage, Order, OrderItem
- Repositories: CategoryRepository, ProductRepository, OrderRepository
- DTOs: CategoryDto, ProductDto, OrderDto, CreateCategoryRequest, CreateProductRequest, CreateOrderRequest
- Exceptions: ResourceNotFoundException, BadRequestException, GlobalExceptionHandler

### d7-admin-service
- Services: CategoryService, ProductService, OrderService
- Controllers: CategoryController, ProductController, OrderController
- Cấu hình: application.yml (port 8081)

### d7-enduser-service
- Services: CategoryService, ProductService, OrderService
- Controllers: CategoryController, ProductController, OrderController
- Cấu hình: application.yml (port 8082)

## API Endpoints

### Admin Service (http://localhost:8081/admin)
- Categories: /api/admin/categories
- Products: /api/admin/products
- Orders: /api/admin/orders

### Enduser Service (http://localhost:8082/api)
- Categories: /api/categories
- Products: /api/products
- Orders: /api/orders

## Công việc đang thực hiện
1. Hoàn thiện các service và controller
2. Chuẩn bị cho việc triển khai security
3. Kiểm thử các API endpoint

## Lưu ý
- Cần triển khai authentication và authorization
- Cần viết tests cho các service
- Cần tạo API documentation
- Cần tối ưu hiệu suất và caching 