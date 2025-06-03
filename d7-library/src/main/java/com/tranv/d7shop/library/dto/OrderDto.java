package com.tranv.d7shop.library.dto;

import com.tranv.d7shop.library.common.OrderStatus;
import com.tranv.d7shop.library.entity.Order;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
public class OrderDto {
    private Long id;
    private Long userId;
    private String username;
    private OrderStatus status;
    private BigDecimal total;
    private String shippingAddress;
    private String shippingPhone;
    private String shippingName;
    private String shippingEmail;
    private String note;
    private LocalDateTime createdAt;
    private List<OrderItemDto> items = new ArrayList<>();
    
    @Data
    public static class OrderItemDto {
        private Long id;
        private Long productId;
        private String productName;
        private String productImage;
        private Integer quantity;
        private BigDecimal price;
        private BigDecimal totalPrice;
    }
} 