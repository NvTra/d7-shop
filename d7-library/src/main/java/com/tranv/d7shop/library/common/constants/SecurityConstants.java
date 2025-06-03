package com.tranv.d7shop.library.common.constants;

public class SecurityConstants {
    public static final String TOKEN_PREFIX = "Bearer ";
    public static final String HEADER_STRING = "Authorization";
    public static final String ROLE_PREFIX = "ROLE_";
    
    // Role names
    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_STAFF = "STAFF";
    public static final String ROLE_USER = "USER";
    
    // API paths
    public static final String API_V1 = "/api/v1";
    public static final String ADMIN_API = API_V1 + "/admin";
    public static final String USER_API = API_V1 + "/user";
    public static final String PUBLIC_API = API_V1 + "/public";
    public static final String AUTH_API = API_V1 + "/auth";
    
    private SecurityConstants() {
        // Private constructor to prevent instantiation
    }
} 