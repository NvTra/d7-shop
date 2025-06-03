package com.tranv.d7shop.library.dto;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class PaymentDto extends BaseDto {
    private Long orderId;
    private BigDecimal amount;
    private String provider;
    private String status;
    private String transactionId;
    private String paymentMethod;
} 