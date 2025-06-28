package com.example.login.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // CSRF 비활성화 (API 서버용)
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/login").permitAll()  // 로그인 API는 인증 없이 접근 허용
                .anyRequest().authenticated()               // 그 외는 인증 필요
            )
            .httpBasic(httpBasic -> httpBasic.disable())    // Basic Auth 비활성화
            .formLogin(form -> form.disable());             // Form 로그인도 비활성화
        return http.build();
    }
}
