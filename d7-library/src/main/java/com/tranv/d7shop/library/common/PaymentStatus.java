package com.tranv.d7shop.library.common;

public enum PaymentStatus {
    PENDING,    // Chờ thanh toán
    PROCESSING, // Đang xử lý
    COMPLETED,  // Đã thanh toán
    FAILED,     // Thanh toán thất bại
    REFUNDED    // Đã hoàn tiền
} 