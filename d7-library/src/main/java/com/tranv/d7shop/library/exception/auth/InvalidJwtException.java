package com.tranv.d7shop.library.exception.auth;

import com.tranv.d7shop.library.exception.BaseException;
import org.springframework.http.HttpStatus;

public class InvalidJwtException extends BaseException {
    public InvalidJwtException(String message) {
        super(message, "AUTH-001", HttpStatus.UNAUTHORIZED);
    }
    
    public InvalidJwtException(String message, Throwable cause) {
        super(message, "AUTH-001", HttpStatus.UNAUTHORIZED, cause);
    }
} 