package com.example.login.dto;

public class LoginRequest {
    private String idToken; // 구글 로그인, Firebase 로그인용
    private String email;   // 비밀번호 변경용

    public LoginRequest() {}

    public LoginRequest(String idToken, String email) {
        this.idToken = idToken;
        this.email = email;
    }

    public String getIdToken() {
        return idToken;
    }

    public void setIdToken(String idToken) {
        this.idToken = idToken;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
