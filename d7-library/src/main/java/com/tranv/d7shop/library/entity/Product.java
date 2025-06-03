package com.tranv.d7shop.library.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "products")
@Getter
@Setter
public class Product extends BaseEntity {

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "slug", nullable = false)
    private String slug;

    @Column(name = "description")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @NotNull
    @Min(0)
    @Column(name = "price", nullable = false)
    private BigDecimal price;

    @Min(0)
    @Column(name = "sale_price")
    private BigDecimal salePrice;

    @NotNull
    @Min(0)
    @Column(name = "stock_quantity", nullable = false)
    private Integer stockQuantity = 0;

    @Column(name = "sku")
    private String sku;

    @Column(name = "status", nullable = false)
    private String status = "ACTIVE";

    @Column(name = "enabled", nullable = false)
    private boolean enabled = true;

    @Column(name = "featured", nullable = false)
    private boolean featured = false;

    @Column(name = "average_rating")
    private Double averageRating;

    @Column(name = "review_count", nullable = false)
    private Integer reviewCount = 0;

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ProductImage> images = new ArrayList<>();

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL)
    private List<ProductReview> reviews = new ArrayList<>();

    public void addImage(ProductImage image) {
        images.add(image);
        image.setProduct(this);
    }

    public void removeImage(ProductImage image) {
        images.remove(image);
        image.setProduct(null);
    }

    public void addReview(ProductReview review) {
        reviews.add(review);
        review.setProduct(this);
        recalculateRating();
    }

    public void removeReview(ProductReview review) {
        reviews.remove(review);
        review.setProduct(null);
        recalculateRating();
    }

    private void recalculateRating() {
        this.reviewCount = reviews.size();
        if (reviewCount > 0) {
            this.averageRating = reviews.stream()
                    .mapToDouble(ProductReview::getRating)
                    .average()
                    .orElse(0.0);
        } else {
            this.averageRating = null;
        }
    }

    @PrePersist
    @PreUpdate
    private void validateSalePrice() {
        if (salePrice != null && price != null && salePrice.compareTo(price) > 0) {
            throw new IllegalStateException("Sale price cannot be greater than regular price");
        }
    }
} 