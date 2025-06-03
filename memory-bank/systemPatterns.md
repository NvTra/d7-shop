# System Patterns Documentation

## Kiến trúc Tổng thể

D7-Shop được xây dựng theo kiến trúc microservices với các thành phần chính:

1. d7-library
   - Thư viện chung chứa entities, repositories, DTOs và các utility classes
   - Quản lý migration database
   - Cấu hình chung cho các service

2. d7-admin-service
   - Quản lý backend cho admin dashboard
   - Xử lý các tác vụ quản trị
   - Báo cáo và thống kê

3. d7-enduser-service
   - Xử lý các tác vụ của người dùng cuối
   - Quản lý giỏ hàng và đơn hàng
   - Tích hợp thanh toán

## Mẫu Thiết kế

### 1. Domain-Driven Design (DDD)
- Entities được tổ chức theo bounded contexts
- Value Objects cho các đối tượng không có identity
- Aggregates để đảm bảo tính nhất quán của dữ liệu
- Domain Events cho các thay đổi quan trọng

### 2. Repository Pattern
```java
public interface BaseRepository<T extends BaseEntity> extends JpaRepository<T, UUID> {
    @Query("SELECT e FROM #{#entityName} e WHERE e.isDeleted = false")
    List<T> findAllActive();
    
    @Query("SELECT e FROM #{#entityName} e WHERE e.id = :id AND e.isDeleted = false")
    Optional<T> findActiveById(@Param("id") UUID id);
    
    @Modifying
    @Query("UPDATE #{#entityName} e SET e.isDeleted = true, e.deletedAt = CURRENT_TIMESTAMP WHERE e.id = :id")
    void softDelete(@Param("id") UUID id);
}
```

### 3. Service Layer Pattern
```java
@Service
@Transactional
public abstract class BaseService<T extends BaseEntity, R extends BaseRepository<T>> {
    @Autowired
    protected R repository;
    
    public T create(T entity) {
        return repository.save(entity);
    }
    
    public T update(T entity) {
        if (!repository.existsById(entity.getId())) {
            throw new ResourceNotFoundException("Entity not found");
        }
        return repository.save(entity);
    }
    
    public void delete(UUID id) {
        repository.softDelete(id);
    }
    
    public Optional<T> findById(UUID id) {
        return repository.findActiveById(id);
    }
    
    public List<T> findAll() {
        return repository.findAllActive();
    }
}
```

### 4. DTO Pattern
```java
@Data
@MappedSuperclass
public abstract class BaseDto implements Serializable {
    private UUID id;
    private LocalDateTime createdAt;
    private String createdBy;
    private LocalDateTime updatedAt;
    private String updatedBy;
}

@Data
@EqualsAndHashCode(callSuper = true)
public class ProductDto extends BaseDto {
    private String name;
    private String description;
    private String sku;
    private BigDecimal price;
    private BigDecimal salePrice;
    private Integer quantity;
    private UUID categoryId;
    private List<String> imageUrls;
}
```

### 5. Audit Pattern
```java
@EntityListeners(AuditingEntityListener.class)
@MappedSuperclass
@Data
public abstract class BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @CreatedBy
    private String createdBy;
    
    @LastModifiedDate
    private LocalDateTime updatedAt;
    
    @LastModifiedBy
    private String updatedBy;
    
    private LocalDateTime deletedAt;
    
    @Column(nullable = false)
    private boolean isDeleted = false;
}
```

### 6. Validation Pattern
```java
public class ValidationUtils {
    public static void validatePrice(BigDecimal price, BigDecimal salePrice) {
        if (price.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Price cannot be negative");
        }
        if (salePrice != null) {
            if (salePrice.compareTo(BigDecimal.ZERO) < 0) {
                throw new IllegalArgumentException("Sale price cannot be negative");
            }
            if (salePrice.compareTo(price) > 0) {
                throw new IllegalArgumentException("Sale price cannot be greater than regular price");
            }
        }
    }
    
    public static void validateQuantity(Integer quantity) {
        if (quantity < 0) {
            throw new IllegalArgumentException("Quantity cannot be negative");
        }
    }
    
    public static void validateRating(Integer rating) {
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
    }
}
```

### 7. Exception Handling Pattern
```java
@ControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<Object> handleResourceNotFoundException(ResourceNotFoundException ex) {
        Map<String, Object> body = new HashMap<>();
        body.put("timestamp", LocalDateTime.now());
        body.put("message", ex.getMessage());
        return new ResponseEntity<>(body, HttpStatus.NOT_FOUND);
    }
    
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Object> handleIllegalArgumentException(IllegalArgumentException ex) {
        Map<String, Object> body = new HashMap<>();
        body.put("timestamp", LocalDateTime.now());
        body.put("message", ex.getMessage());
        return new ResponseEntity<>(body, HttpStatus.BAD_REQUEST);
    }
}
```

### 8. Event Pattern
```java
@Data
@SuperBuilder
public abstract class DomainEvent {
    private final UUID eventId;
    private final LocalDateTime timestamp;
    private final String type;
}

@Data
@SuperBuilder
public class OrderCreatedEvent extends DomainEvent {
    private final UUID orderId;
    private final UUID userId;
    private final BigDecimal totalAmount;
}

@Service
public class OrderEventHandler {
    @Async
    @EventListener
    public void handleOrderCreated(OrderCreatedEvent event) {
        // Xử lý sự kiện đơn hàng được tạo
        // - Gửi email xác nhận
        // - Cập nhật inventory
        // - Tạo payment request
    }
}
```

## Nguyên tắc Thiết kế

### SOLID Principles
1. Single Responsibility Principle
   - Mỗi class chỉ có một trách nhiệm
   - Tách biệt các concerns

2. Open/Closed Principle
   - Sử dụng interfaces và abstract classes
   - Dễ dàng mở rộng, không cần sửa đổi code hiện có

3. Liskov Substitution Principle
   - BaseEntity và BaseDto làm nền tảng
   - Các lớp con có thể thay thế lớp cha

4. Interface Segregation Principle
   - Tách biệt các interface theo chức năng
   - Repository interfaces phù hợp với domain

5. Dependency Inversion Principle
   - Sử dụng dependency injection
   - Loose coupling giữa các components

### Clean Code Principles
1. Meaningful Names
   - Đặt tên rõ ràng, dễ hiểu
   - Tuân thủ coding conventions

2. Small Functions
   - Mỗi function làm một việc
   - Dễ test và maintain

3. DRY (Don't Repeat Yourself)
   - Tái sử dụng code qua base classes
   - Tránh duplicate logic

4. KISS (Keep It Simple, Stupid)
   - Thiết kế đơn giản, dễ hiểu
   - Tránh over-engineering

## Cấu trúc Package

```
com.tranv.d7shop
├── library
│   ├── common
│   │   └── enums
│   ├── config
│   ├── dto
│   │   └── request
│   ├── entity
│   ├── exception
│   └── repository
├── admin
│   ├── controller
│   └── service
└── enduser
    ├── controller
    └── service
```

## Database Schema

### Base Entity
- UUID primary key
- Audit fields (created_at, created_by, updated_at, updated_by)
- Soft delete (is_deleted, deleted_at)

### Categories
- Hỗ trợ danh mục đa cấp
- Soft delete với is_deleted và deleted_at
- Tracking audit fields

### Products
- Liên kết với category bằng UUID
- Quản lý hình ảnh sản phẩm
- Quản lý giá và tồn kho
- Tracking đánh giá sản phẩm
- Tracking audit fields

### Orders
- Lưu thông tin đơn hàng
- Quản lý trạng thái đơn hàng
- Chi tiết đơn hàng với order items
- Tracking audit fields

## Security
- JWT based authentication
- Role based authorization
- API endpoint protection
- Input validation

## Logging & Monitoring
- Structured logging
- Log rotation
- Health checks
- Application metrics

## Error Handling
- Global exception handling
- Custom exceptions
- Meaningful error messages
- HTTP status codes mapping

## Các mẫu thiết kế
### Architectural Patterns
- MVC/REST
- Repository Pattern
- Dependency Injection
- DTO Pattern
- Factory Pattern (cho các service phức tạp)
- Audit Pattern (cho tracking thay đổi)

### Design Patterns
- Builder Pattern (cho các DTO phức tạp)
- Strategy Pattern (cho các service có nhiều implementation)
- Observer Pattern (cho event handling)
- Chain of Responsibility (cho request filtering)
- Adapter Pattern (cho third-party integrations)

## Các thành phần chính
### Backend
#### Controllers
- AuthController
- UserController
- ProductController
- CategoryController
- CartController
- OrderController
- PaymentController
- AdminController

#### Services
- AuthService
- UserService
- ProductService
- CategoryService
- CartService
- OrderService
- PaymentService
- FileStorageService
- EmailService
- AuditService

#### Repositories
- BaseRepository (với soft delete)
- UserRepository
- ProductRepository
- CategoryRepository
- CartRepository
- OrderRepository
- AddressRepository
- ReviewRepository

#### Models/Entities
- BaseEntity (UUID + audit)
- User
- Product
- Category
- Cart
- CartItem
- Order
- OrderItem
- Address
- Review
- Payment

#### DTOs
- BaseDto (UUID)
- UserDTO
- ProductDTO
- CategoryDTO
- CartDTO
- OrderDTO
- AddressDTO
- ReviewDTO

#### Utilities
- JwtUtil
- SecurityUtil
- ValidationUtil
- DateTimeUtil
- FileUtil
- AuditUtil

### Frontend
- Templates (Thymeleaf)
- Static resources
- Layouts
- Components

### Database
#### Schemas
- users
- products
- categories
- carts
- orders
- addresses
- reviews
- payments

#### Migrations
- V1: Tạo bảng users, categories, user_addresses
- V2: Tạo bảng products, product_images, product_reviews
- V3: Tạo bảng carts, orders, payments
- V4: Thêm dữ liệu mẫu

#### Indexes
- Primary keys (UUID)
- Foreign keys (UUID)
- Search indexes
- Performance indexes
- Soft delete indexes

#### Relationships
- User - Orders (1:N)
- User - Addresses (1:N)
- Product - Category (N:1)
- Order - OrderItems (1:N)
- Product - Reviews (1:N)

## Quy tắc thiết kế
### API Design
- RESTful principles
- Resource naming conventions
- HTTP methods usage
- Status codes
- Error handling
- Versioning strategy

### Security
- Authentication flow
- Authorization rules
- Password policies
- Token management
- CORS policies

### Database
- UUID cho primary key
- Audit fields cho tracking
- Soft delete implementation
- Indexing strategy
- Transaction management
- Connection pooling
- Query optimization

### Code Organization
- Package structure
- Naming conventions
- Code style guide
- Documentation standards
- Testing strategy

## Các quyết định kiến trúc
### Authentication
- Sử dụng JWT cho stateless authentication
- Token expiration và refresh strategy
- Role-based access control

### Database
- PostgreSQL cho RDBMS
- UUID cho primary key
- Flyway cho database migration
- Connection pooling với HikariCP
- Audit fields và soft delete

### Caching
- Redis cho distributed caching
- Local caching với Caffeine
- Cache invalidation strategy
- Cache synchronization

### File Storage
- Local storage cho development
- S3 compatible storage cho production
- File naming strategy
- File type validation

### Monitoring
- Health checks
- Metrics collection
- Log aggregation
- Performance monitoring

### Deployment
- Docker containers
- Kubernetes orchestration
- CI/CD pipeline
- Environment configuration

## Giới hạn và ràng buộc
### Technical
- Java 17+ requirement
- PostgreSQL compatibility
- Memory constraints
- Network latency

### Business
- Transaction consistency
- Data privacy
- Regulatory compliance

## Khả năng mở rộng
### Horizontal Scaling
- Stateless design
- Database sharding strategy
- Load balancing

### Vertical Scaling
- Resource optimization
- Performance tuning
- Memory management

### Future Considerations
- Microservices migration path
- Event-driven architecture
- Cache distribution
- Message queuing 