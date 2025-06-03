package com.tranv.d7shop.library.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Data
public class ProductDto {
    private Long id;
    private String name;
    private String slug;
    private String description;
    private BigDecimal price;
    private BigDecimal salePrice;
    private Integer stockQuantity;
    private Long categoryId;
    private String categoryName;
    private List<ProductImageDto> images = new ArrayList<>();
    private boolean enabled;
    private boolean featured;
    private Double averageRating;
    private Integer reviewCount;
    
    @Data
    public static class ProductImageDto {
        private Long id;
        private String imageUrl;
        private Integer displayOrder;
        private boolean primary;
    }
} 