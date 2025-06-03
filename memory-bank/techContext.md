# Technical Context

## Technology Stack

### Backend
- Java 17
- Spring Boot 3.2.x
- Spring Data JPA
- Spring Security
- Spring Cloud
- MapStruct
- Lombok
- Flyway

### Database
- PostgreSQL 15
- UUID for primary keys
- Soft delete pattern
- Audit fields
- Optimized indexes

### Tools & Libraries
- Maven
- JUnit 5
- Mockito
- OpenAPI/Swagger
- Docker
- Git

## Architecture

### Microservices
1. d7-library
   - Common library
   - Shared components
   - Database migrations
   - Entity definitions

2. d7-admin-service
   - Admin dashboard backend
   - Product management
   - Order management
   - User management

3. d7-enduser-service
   - Public API
   - Shopping cart
   - Order processing
   - Payment integration

### Database Design
- UUID primary keys
- Audit fields (created_at, updated_at, etc.)
- Soft delete pattern
- Optimized indexes
- Data validation constraints

### Security
- JWT authentication
- Role-based authorization
- Password encryption
- API security

### Testing
- Unit tests
- Integration tests
- Performance tests
- Security tests

## Development Practices

### Code Quality
- Clean code principles
- SOLID principles
- Design patterns
- Code reviews

### Version Control
- Git flow
- Feature branches
- Pull requests
- Code reviews

### Documentation
- API documentation
- Code documentation
- Architecture documentation
- Deployment guide

### CI/CD
- Automated builds
- Unit tests
- Integration tests
- Deployment automation

## Environment Setup

### Development
- JDK 17
- PostgreSQL 15
- Maven
- Git
- Docker
- IDE (IntelliJ/Eclipse)

### Testing
- JUnit 5
- Mockito
- TestContainers
- Postman

### Production
- Docker containers
- Load balancer
- Monitoring
- Logging

## Development Environment

### Required Software
- JDK 17
- Maven 3.8+
- PostgreSQL 15
- Docker
- Git

### IDE Setup
- IntelliJ IDEA / Eclipse
- Lombok plugin
- Spring Boot plugin
- Database tools

### Build & Run
```bash
# Build all modules
mvn clean install

# Run specific service
cd d7-admin-service
mvn spring-boot:run

cd d7-enduser-service
mvn spring-boot:run
```

### Database Setup
```bash
# Create database
createdb d7shop

# Run migrations
mvn flyway:migrate
```

## Testing Strategy

### Unit Tests
- JUnit 5
- Mockito
- AssertJ
- Test containers

### Integration Tests
- Spring Boot Test
- Test containers
- REST Assured

### Performance Tests
- JMeter
- Gatling

## Deployment

### Development
- Local environment
- Docker compose
- H2 database (optional)

### Staging
- Docker containers
- PostgreSQL
- Nginx reverse proxy

### Production
- Kubernetes
- PostgreSQL cluster
- Load balancer
- Monitoring

## Monitoring & Logging

### Metrics
- Micrometer
- Prometheus
- Grafana

### Logging
- Logback
- ELK Stack
- Log rotation

### Tracing
- Spring Cloud Sleuth
- Zipkin

## Documentation

### API Documentation
- OpenAPI/Swagger
- Postman collections
- API guidelines

### Code Documentation
- Javadoc
- README files
- Architecture diagrams

### User Documentation
- User guides
- Admin guides
- API guides 