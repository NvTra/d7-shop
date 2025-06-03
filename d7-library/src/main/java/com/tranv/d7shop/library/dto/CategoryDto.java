package com.tranv.d7shop.library.dto;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class CategoryDto {
    private Long id;
    private String name;
    private String description;
    private String imageUrl;
    private Long parentId;
    private boolean enabled;
    private Integer displayOrder;
    private List<CategoryDto> children = new ArrayList<>();
} 