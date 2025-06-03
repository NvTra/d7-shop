#!/bin/bash

echo "Bắt đầu thiết lập môi trường phát triển D7-Shop..."

# Kiểm tra các công cụ cần thiết
check_requirements() {
    echo "Kiểm tra các công cụ cần thiết..."
    
    # Kiểm tra Java
    if ! command -v java &> /dev/null; then
        echo "❌ Java chưa được cài đặt"
        exit 1
    fi
    java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo "✅ Java đã được cài đặt: $java_version"
    
    # Kiểm tra Maven
    if ! command -v mvn &> /dev/null; then
        echo "❌ Maven chưa được cài đặt"
        exit 1
    fi
    mvn_version=$(mvn --version | awk 'NR==1{print $3}')
    echo "✅ Maven đã được cài đặt: $mvn_version"
    
    # Kiểm tra PostgreSQL
    if ! command -v psql &> /dev/null; then
        echo "❌ PostgreSQL chưa được cài đặt"
        exit 1
    fi
    pg_version=$(psql --version | awk '{print $3}')
    echo "✅ PostgreSQL đã được cài đặt: $pg_version"
}

# Thiết lập database
setup_database() {
    echo "Thiết lập database..."
    
    # Tạo database và user
    psql -U postgres -c "CREATE DATABASE d7shop;" || true
    psql -U postgres -c "CREATE DATABASE d7shop_test;" || true
    psql -U postgres -c "CREATE USER d7shop_dev WITH ENCRYPTED PASSWORD 'dev_password';" || true
    psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE d7shop TO d7shop_dev;" || true
    psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE d7shop_test TO d7shop_dev;" || true
    
    echo "✅ Database đã được thiết lập"
}

# Thiết lập file môi trường
setup_env() {
    echo "Thiết lập file môi trường..."
    
    if [ ! -f .env ]; then
        cp .env.example .env
        echo "✅ File .env đã được tạo từ template"
    else
        echo "⚠️ File .env đã tồn tại"
    fi
}

# Chạy migration
run_migrations() {
    echo "Chạy database migrations..."
    
    ./mvnw flyway:migrate
    echo "✅ Database migrations đã được thực thi"
}

# Kiểm tra và tạo thư mục cần thiết
setup_directories() {
    echo "Thiết lập các thư mục cần thiết..."
    
    mkdir -p src/main/resources/static/uploads
    mkdir -p logs
    echo "✅ Các thư mục đã được tạo"
}

# Hàm main
main() {
    check_requirements
    setup_database
    setup_env
    setup_directories
    run_migrations
    
    echo "✅ Thiết lập môi trường phát triển hoàn tất!"
    echo "🚀 Bạn có thể bắt đầu phát triển D7-Shop"
    echo "📝 Xem thêm hướng dẫn trong file README.md"
}

# Chạy script
main 