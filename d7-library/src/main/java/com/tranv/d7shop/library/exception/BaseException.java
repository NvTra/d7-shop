package com.tranv.d7shop.library.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public abstract class BaseException extends RuntimeException {
    private final String code;
    private final HttpStatus status;
    
    protected BaseException(String message, String code, HttpStatus status) {
        super(message);
        this.code = code;
        this.status = status;
    }
    
    protected BaseException(String message, String code, HttpStatus status, Throwable cause) {
        super(message, cause);
        this.code = code;
        this.status = status;
    }
} 