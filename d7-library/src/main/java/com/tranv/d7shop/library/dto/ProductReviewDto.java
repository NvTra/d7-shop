package com.tranv.d7shop.library.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductReviewDto extends BaseDto {
    private Long productId;
    private Long userId;
    private String userName;
    private Integer rating;
    private String comment;
    private String status;
} 