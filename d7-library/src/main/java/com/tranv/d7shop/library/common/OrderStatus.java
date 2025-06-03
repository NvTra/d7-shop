package com.tranv.d7shop.library.common;

public enum OrderStatus {
    PENDING,        // Đơn hàng mới tạo
    CONFIRMED,      // Đã xác nhận đơn hàng
    PROCESSING,     // Đang xử lý
    SHIPPING,       // Đang vận chuyển
    DELIVERED,      // Đã giao hàng
    COMPLETED,      // Hoàn thành
    CANCELLED,      // Đã hủy
    REFUNDED       // Đã hoàn tiền
} 