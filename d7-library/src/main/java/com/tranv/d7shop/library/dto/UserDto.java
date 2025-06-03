package com.tranv.d7shop.library.dto;

import lombok.Data;

@Data
public class UserDto {
    private Long id;
    private String username;
    private String fullName;
    private String email;
    private String role;
    private boolean enabled;
} 