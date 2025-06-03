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
public interface BaseRepository<T, ID> extends JpaRepository<T, ID> {
    // Soft delete methods
    @Query("UPDATE #{#entityName} e SET e.deletedAt = CURRENT_TIMESTAMP, e.isDeleted = true WHERE e.id = :id")
    void softDelete(@Param("id") ID id);
    
    // Custom find methods
    @Query("SELECT e FROM #{#entityName} e WHERE e.isDeleted = false")
    List<T> findAllActive();
}

public interface ProductRepository extends BaseRepository<Product, UUID> {
    // Custom queries
    @Query("SELECT p FROM Product p WHERE p.category.id = :categoryId AND p.isDeleted = false")
    List<Product> findByCategoryId(@Param("categoryId") UUID categoryId);
}
```

### 3. Service Layer Pattern
```java
@Service
@Transactional
public class BaseService<T, ID> {
    @Autowired
    protected BaseRepository<T, ID> repository;
    
    public T save(T entity) {
        // Validation and business logic
        return repository.save(entity);
    }
    
    public void delete(ID id) {
        repository.softDelete(id);
    }
}

@Service
public class ProductService extends BaseService<Product, UUID> {
    @Autowired
    private CategoryService categoryService;
    
    public Product create(ProductDTO dto) {
        // Custom business logic
        validateProduct(dto);
        return super.save(mapToEntity(dto));
    }
}
```

### 4. DTO Pattern
```java
public class BaseDTO {
    private UUID id;
    private LocalDateTime createdAt;
    private String createdBy;
    private LocalDateTime updatedAt;
    private String updatedBy;
}

public class ProductDTO extends BaseDTO {
    private String name;
    private String slug;
    private String description;
    private UUID categoryId;
    private BigDecimal price;
    private BigDecimal salePrice;
    private Integer stockQuantity;
    private String sku;
    private String status;
    private Boolean enabled;
    private Boolean featured;
    private Double averageRating;
    private Integer reviewCount;
}
```

### 5. Mapper Pattern
```java
@Mapper(componentModel = "spring")
public interface BaseMapper<D extends BaseDTO, E> {
    D toDto(E entity);
    E toEntity(D dto);
    List<D> toDtoList(List<E> entities);
    List<E> toEntityList(List<D> dtos);
}

@Mapper(componentModel = "spring")
public interface ProductMapper extends BaseMapper<ProductDTO, Product> {
    @Mapping(source = "category.id", target = "categoryId")
    ProductDTO toDto(Product product);
    
    @Mapping(source = "categoryId", target = "category.id")
    Product toEntity(ProductDTO dto);
}
```

### 6. Controller Pattern
```java
@RestController
@RequestMapping("/api/v1")
public class BaseController<T, D extends BaseDTO, ID> {
    @Autowired
    protected BaseService<T, ID> service;
    @Autowired
    protected BaseMapper<D, T> mapper;
    
    @GetMapping
    public List<D> findAll() {
        return mapper.toDtoList(service.findAll());
    }
    
    @PostMapping
    public D create(@Valid @RequestBody D dto) {
        return mapper.toDto(service.save(mapper.toEntity(dto)));
    }
}

@RestController
@RequestMapping("/api/v1/products")
public class ProductController extends BaseController<Product, ProductDTO, UUID> {
    @GetMapping("/category/{categoryId}")
    public List<ProductDTO> findByCategory(@PathVariable UUID categoryId) {
        return mapper.toDtoList(((ProductService) service).findByCategoryId(categoryId));
    }
}
```

### 7. Exception Handling Pattern
```java
@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleResourceNotFound(ResourceNotFoundException ex) {
        return new ResponseEntity<>(new ErrorResponse(ex.getMessage()), HttpStatus.NOT_FOUND);
    }
    
    @ExceptionHandler(ValidationException.class)
    public ResponseEntity<ErrorResponse> handleValidation(ValidationException ex) {
        return new ResponseEntity<>(new ErrorResponse(ex.getMessage()), HttpStatus.BAD_REQUEST);
    }
}
```

### 8. Validation Pattern
```java
public class ValidationUtils {
    public static void validatePrice(BigDecimal price, BigDecimal salePrice) {
        if (price == null || price.compareTo(BigDecimal.ZERO) < 0) {
            throw new ValidationException("Price must be greater than or equal to 0");
        }
        if (salePrice != null) {
            if (salePrice.compareTo(BigDecimal.ZERO) < 0) {
                throw new ValidationException("Sale price must be greater than or equal to 0");
            }
            if (salePrice.compareTo(price) > 0) {
                throw new ValidationException("Sale price cannot be greater than regular price");
            }
        }
    }
}
```

### 9. Audit Pattern
```java
@EntityListeners(AuditingEntityListener.class)
@MappedSuperclass
public abstract class BaseEntity {
    @Id
    @GeneratedValue(generator = "UUID")
    private UUID id;
    
    @CreatedDate
    private LocalDateTime createdAt;
    
    @CreatedBy
    private String createdBy;
    
    @LastModifiedDate
    private LocalDateTime updatedAt;
    
    @LastModifiedBy
    private String updatedBy;
    
    private LocalDateTime deletedAt;
    private Boolean isDeleted = false;
}
```

### 10. Event Pattern
```java
public class DomainEvent<T> {
    private final T entity;
    private final String action;
    private final LocalDateTime timestamp;
    private final String username;
}

@Service
public class EventPublisher {
    @Autowired
    private ApplicationEventPublisher publisher;
    
    public <T> void publish(T entity, String action) {
        DomainEvent<T> event = new DomainEvent<>(entity, action, 
            LocalDateTime.now(), SecurityUtils.getCurrentUsername());
        publisher.publishEvent(event);
    }
}
```

## Nguyên tắc Thiết kế

1. SOLID Principles
   - Single Responsibility: Mỗi class chỉ có một trách nhiệm
   - Open/Closed: Mở rộng thông qua kế thừa, không sửa đổi code hiện có
   - Liskov Substitution: Các class con có thể thay thế class cha
   - Interface Segregation: Chia nhỏ interface theo chức năng
   - Dependency Inversion: Phụ thuộc vào abstraction

2. Clean Code
   - Đặt tên có ý nghĩa
   - Hàm ngắn gọn, rõ ràng
   - Tránh duplicate code
   - Unit test đầy đủ
   - Documentation rõ ràng

3. Security
   - Validation input
   - Xử lý exception
   - Audit logging
   - Role-based access control
   - Secure communication

4. Performance
   - Caching
   - Lazy loading
   - Index optimization
   - Connection pooling
   - Query optimization

## Cấu trúc Package

### d7-library
```
com.tranv.d7shop.library
├── config/         # Cấu hình chung
├── dto/           # Data Transfer Objects
├── entity/        # JPA Entities
├── exception/     # Custom Exceptions
└── repository/    # JPA Repositories
```

### d7-admin-service & d7-enduser-service
```
com.tranv.d7shop.[admin|enduser]
├── controller/    # REST Controllers
└── service/      # Business Services
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