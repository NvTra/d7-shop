package com.tranv.d7shop.library.dto;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class CartDto extends BaseDto {
    private Long userId;
    private List<CartItemDto> items = new ArrayList<>();
    private BigDecimal totalAmount = BigDecimal.ZERO;
    private int totalItems = 0;
} 