package com.tranv.d7shop.library.dto.request;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
public class CreateOrderRequest {
    @NotNull(message = "Shipping address ID is required")
    private UUID shippingAddressId;

    @NotEmpty(message = "Order items cannot be empty")
    private List<OrderItemRequest> items;

    private String notes;

    @NotNull(message = "Payment method is required")
    private String paymentMethod;

    @Getter
    @Setter
    public static class OrderItemRequest {
        @NotNull(message = "Product ID is required")
        private UUID productId;

        @NotNull(message = "Quantity is required")
        private Integer quantity;
    }
} 