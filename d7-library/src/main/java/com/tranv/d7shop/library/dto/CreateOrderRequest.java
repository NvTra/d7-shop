package com.tranv.d7shop.library.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class CreateOrderRequest {
    
    @NotBlank(message = "Shipping address is required")
    private String shippingAddress;
    
    @NotBlank(message = "Shipping phone is required")
    private String shippingPhone;
    
    @NotBlank(message = "Shipping name is required")
    private String shippingName;
    
    private String shippingEmail;
    
    @Size(max = 1000, message = "Note must not exceed 1000 characters")
    private String note;
    
    @NotEmpty(message = "Order must have at least one item")
    @Valid
    private List<CreateOrderItemRequest> items = new ArrayList<>();
    
    @Data
    public static class CreateOrderItemRequest {
        @NotNull(message = "Product ID is required")
        private Long productId;
        
        @NotNull(message = "Quantity is required")
        private Integer quantity;
    }
} 