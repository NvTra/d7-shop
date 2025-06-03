package com.tranv.d7shop.library.exception.auth;

import com.tranv.d7shop.library.exception.BaseException;
import org.springframework.http.HttpStatus;

public class TokenExpiredException extends BaseException {
    public TokenExpiredException() {
        super("Token đã hết hạn", "AUTH-002", HttpStatus.UNAUTHORIZED);
    }
    
    public TokenExpiredException(String message) {
        super(message, "AUTH-002", HttpStatus.UNAUTHORIZED);
    }
} 