package com.tranv.d7shop.library.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Data
public class CreateProductRequest {
    
    @NotBlank(message = "Product name is required")
    @Size(max = 255, message = "Product name must not exceed 255 characters")
    private String name;
    
    @Size(max = 2000, message = "Description must not exceed 2000 characters")
    private String description;
    
    @NotNull(message = "Price is required")
    @Min(value = 0, message = "Price must be greater than or equal to 0")
    private BigDecimal price;
    
    @Min(value = 0, message = "Sale price must be greater than or equal to 0")
    private BigDecimal salePrice;
    
    @NotNull(message = "Stock quantity is required")
    @Min(value = 0, message = "Stock quantity must be greater than or equal to 0")
    private Integer stockQuantity;
    
    @NotNull(message = "Category is required")
    private Long categoryId;
    
    private List<CreateProductImageRequest> images = new ArrayList<>();
    private boolean enabled = true;
    private boolean featured;
    
    @Data
    public static class CreateProductImageRequest {
        @NotBlank(message = "Image URL is required")
        private String imageUrl;
        private Integer displayOrder;
        private boolean primary;
    }
} 