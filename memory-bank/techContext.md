# Ngữ cảnh Kỹ thuật: D7-Shop
*Phiên bản: 1.0*
*Tạo: 2024-03-21*
*Cập nhật lần cuối: 2024-03-21*

## Tech Stack
- Java 17+
- Spring Boot 3.1.5
- PostgreSQL 15+
- Spring Security với JWT
- Flyway Migration
- Spring Data JPA
- Swagger/OpenAPI 3.0
- Maven

## Cấu trúc Dự án
1. d7-library
   - Common utilities và configurations
   - Shared entities và DTOs
   - Security configurations
   - Database migrations

2. d7-admin-service
   - Admin API endpoints
   - Admin-specific configurations
   - Admin security rules

3. d7-enduser-service
   - Public API endpoints
   - User-specific configurations
   - Public security rules

## Database Design
- UUID cho primary keys
- Soft delete pattern
- Audit fields (created_at, updated_at, etc.)
- Role-based access control
- Optimistic locking
- Database-level constraints
- Appropriate indexes

## Security Implementation
- JWT based authentication
- Role-based authorization
- Method level security
- API endpoint protection
- CORS configuration
- Password encryption
- Token management

## Development Guidelines
1. Code Style
   - Clean code principles
   - SOLID principles
   - Consistent naming conventions
   - Proper documentation

2. API Design
   - RESTful principles
   - Proper HTTP methods
   - Consistent response format
   - Proper error handling
   - API versioning

3. Testing
   - Unit tests
   - Integration tests
   - API tests
   - Security tests

## Monitoring & Logging
- Structured logging
- Performance metrics
- Error tracking
- Audit logging
- Health checks

## Deployment
- Environment configurations
- Docker support (planned)
- CI/CD pipeline (planned)
- Backup strategy
- Scaling strategy

## Performance Considerations
- Connection pooling
- Query optimization
- Caching strategy
- Batch processing
- Async operations

## Documentation
- API documentation (Swagger)
- Technical documentation
- Development guides
- Deployment guides

---

*Tài liệu này định nghĩa ngữ cảnh kỹ thuật và hướng dẫn phát triển cho dự án.* 