package com.tranv.d7shop.library.entity;

import com.tranv.d7shop.library.common.PaymentStatus;
import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Entity
@Table(name = "payments")
@Getter
@Setter
public class Payment extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;

    @NotNull
    @Min(0)
    @Column(name = "amount", nullable = false)
    private BigDecimal amount;

    @Column(name = "provider", nullable = false)
    private String provider;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private PaymentStatus status = PaymentStatus.PENDING;

    @Column(name = "transaction_id", unique = true)
    private String transactionId;

    @Column(name = "payment_method", nullable = false)
    private String paymentMethod;

    public void updateStatus(PaymentStatus newStatus) {
        this.status = newStatus;
        if (order != null) {
            if (newStatus == PaymentStatus.COMPLETED) {
                order.setPaymentStatus("PAID");
            } else if (newStatus == PaymentStatus.FAILED) {
                order.setPaymentStatus("FAILED");
            }
        }
    }
} 