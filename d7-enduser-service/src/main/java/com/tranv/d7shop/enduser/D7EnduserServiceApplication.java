package com.tranv.d7shop.enduser;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@ComponentScan(basePackages = {"com.tranv.d7shop.library", "com.tranv.d7shop.enduser"})
@EntityScan(basePackages = {"com.tranv.d7shop.library.entity"})
@EnableJpaRepositories(basePackages = {"com.tranv.d7shop.library.repository"})
public class D7EnduserServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(D7EnduserServiceApplication.class, args);
    }
} 