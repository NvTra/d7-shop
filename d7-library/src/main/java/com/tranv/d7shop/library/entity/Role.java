package com.tranv.d7shop.library.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "roles")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Role extends BaseEntity {
    @Column(nullable = false, unique = true)
    private String name;
    
    @Column
    private String description;
    
    @OneToMany(mappedBy = "role")
    @Builder.Default
    private List<User> users = new ArrayList<>();
} 